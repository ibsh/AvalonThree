//
//  InGameTransaction+InputMessage+Action+Block+RollForArmour.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionRollForArmour() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let actionContext = try turnContext.actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            ),
            let results = actionContext.history.lastResult(
                { entry -> [BlockDieResult]? in
                    guard case .blockResults(let results) = entry else { return nil }
                    return results
                }
            ),
            let result = actionContext.history.lastResult(
                { entry -> BlockDieResult? in
                    guard case .blockResult(let result) = entry else { return nil }
                    return result
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetPlayerSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        guard let armourStat = targetPlayer.spec.armour else {
            return try blockActionTargetPlayerInjured()
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .bladedKnuckleDusters }
            ),
            !actionContext.history.contains(.eligibleForBladedKnuckleDustersBonusPlay),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: .bladedKnuckleDusters)
            )
        {
            history.append(.eligibleForBladedKnuckleDustersBonusPlay)
            return AddressedPrompt(
                coachID: actionContext.coachID,
                prompt: .blockActionEligibleForBladedKnuckleDustersBonusPlay(
                    playerID: actionContext.playerID,
                    playerSquare: playerSquare
                )
            )
        }

        if
            table.getHand(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .absolutelyNails }
            ),
            !actionContext.history.contains(.eligibleForAbsolutelyNailsBonusPlay),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .absolutelyNails)
            )
        {
            history.append(.eligibleForAbsolutelyNailsBonusPlay)
            return AddressedPrompt(
                coachID: targetPlayerID.coachID,
                prompt: .blockActionEligibleForAbsolutelyNailsBonusPlay(
                    playerID: targetPlayerID,
                    playerSquare: targetPlayerSquare
                )
            )
        }

        if
            table.getHand(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .toughEnough }
            ),
            !table.getActiveBonuses(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .absolutelyNails }
            ),
            !actionContext.history.contains(.eligibleForToughEnoughBonusPlay),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .toughEnough)
            )
        {
            history.append(.eligibleForToughEnoughBonusPlay)
            return AddressedPrompt(
                coachID: targetPlayerID.coachID,
                prompt: .blockActionEligibleForToughEnoughBonusPlay(
                    playerID: targetPlayerID,
                    playerSquare: targetPlayerSquare
                )
            )
        }

        if
            table.getHand(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .pro }
            ),
            !table.getActiveBonuses(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .absolutelyNails }
            ),
            !actionContext.history.contains(.blockActionEligibleForProBonusPlay),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .pro)
            )
        {
            history.append(.blockActionEligibleForProBonusPlay)

            return AddressedPrompt(
                coachID: targetPlayerID.coachID,
                prompt: .blockActionEligibleForProBonusPlay(
                    playerID: targetPlayerID,
                    playerSquare: targetPlayerSquare
                )
            )
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .absoluteCarnage }
            ),
            !table.getActiveBonuses(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .absolutelyNails }
            ),
            !actionContext.history.contains(.eligibleForAbsoluteCarnageBonusPlay),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: .absoluteCarnage)
            )
        {
            history.append(.eligibleForAbsoluteCarnageBonusPlay)
            return AddressedPrompt(
                coachID: actionContext.coachID,
                prompt: .blockActionEligibleForAbsoluteCarnageBonusPlay(
                    playerID: actionContext.playerID,
                    playerSquare: playerSquare
                )
            )
        }

        var targetInjured = false

        var modifier = 0

        var modifications = [ArmourRollModification]()

        if result == .kerrunch {
            modifications.append(.kerrunch)
            modifier -= 1
        }

        modifier = max(-1, modifier)

        if table.getActiveBonuses(
            coachID: actionContext.coachID
        ).contains(
            where: { $0.bonusPlay == .absoluteCarnage }
        ) {
            modifications.append(.absoluteCarnageBonusPlay)
            modifier -= TableConstants.absoluteCarnageBonusPlayArmourDelta
        }

        let randomizer: DXRandomizing = {
            let bonusPlays: Set<BonusPlay> = [.toughEnough, .pro]
            if table.getActiveBonuses(
                coachID: targetPlayer.coachID
            ).contains(
                where: { bonusPlays.contains($0.bonusPlay) }
            ) {
                return randomizers.d8
            } else {
                return randomizers.d6
            }
        }()

        let unmodifiedRoll = randomizer.roll()
        events.append(
            .rolledForArmour(
                coachID: targetPlayer.coachID,
                die: randomizer.die,
                unmodified: unmodifiedRoll
            )
        )

        let immediateSuccess: Int = {
            if table.getActiveBonuses(
                coachID: targetPlayer.coachID
            ).contains(
                where: { $0.bonusPlay == .absolutelyNails }
            ) {
                return TableConstants.absolutelyNailsBonusPlayArmourSuccess
            } else {
                return TableConstants.rollOfSix
            }
        }()

        if unmodifiedRoll < immediateSuccess {

            let modifiedRoll = (unmodifiedRoll + modifier).clamp(randomizer.range)

            if modifiedRoll != unmodifiedRoll {
                events.append(
                    .changedArmourResult(
                        die: randomizer.die,
                        unmodified: unmodifiedRoll,
                        modified: modifiedRoll,
                        modifications: modifications
                    )
                )
            }

            targetInjured = unmodifiedRoll <= TableConstants.rollOfOne || modifiedRoll < armourStat

            if
                targetInjured,
                !actionContext.history.contains(
                    .armourResultEligibleForRawTalentBonusPlayReroll
                ),
                table.getHand(coachID: targetPlayerID.coachID).contains(
                    where: { $0.bonusPlay == .rawTalent }
                ),
                !turnContext.history.contains(
                    .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .rawTalent)
                )
            {
                history.append(.armourResultEligibleForRawTalentBonusPlayReroll)
                return AddressedPrompt(
                    coachID: targetPlayerID.coachID,
                    prompt: .blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
                        playerID: targetPlayerID,
                        playerSquare: playerSquare,
                        result: modifiedRoll
                    )
                )
            }
        }

        if targetInjured {
            return try blockActionTargetPlayerInjured()
        }

        if player.spec.skills.contains(.enforcer), results.count > 1 {
            return try blockActionContinueWithEnforcer()
        }

        return try endBlockAction()
    }
}
