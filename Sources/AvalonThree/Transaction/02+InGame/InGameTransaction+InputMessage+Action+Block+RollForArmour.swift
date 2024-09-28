//
//  InGameTransaction+InputMessage+Action+Block+RollForArmour.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionRollForArmour() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
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

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let armourStat = targetPlayer.spec.armour else {
            return try blockActionTargetPlayerInjured()
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .bladedKnuckleDusters }
            ),
            !actionContext.history.contains(.eligibleForBladedKnuckleDustersBonusPlay)
        {
            history.append(.eligibleForBladedKnuckleDustersBonusPlay)
            return Prompt(
                coachID: actionContext.coachID,
                payload: .blockActionEligibleForBladedKnuckleDustersBonusPlay(
                    playerID: actionContext.playerID
                )
            )
        }

        if
            table.getHand(coachID: targetPlayer.coachID).contains(
                where: { $0.bonusPlay == .absolutelyNails }
            ),
            !actionContext.history.contains(.eligibleForAbsolutelyNailsBonusPlay)
        {
            history.append(.eligibleForAbsolutelyNailsBonusPlay)
            return Prompt(
                coachID: targetPlayerID.coachID,
                payload: .blockActionEligibleForAbsolutelyNailsBonusPlay(
                    playerID: targetPlayerID
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
            !actionContext.history.contains(.eligibleForToughEnoughBonusPlay)
        {
            history.append(.eligibleForToughEnoughBonusPlay)
            return Prompt(
                coachID: targetPlayerID.coachID,
                payload: .blockActionEligibleForToughEnoughBonusPlay(
                    playerID: targetPlayerID
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
            !actionContext.history.contains(.blockActionEligibleForProBonusPlay)
        {
            history.append(.blockActionEligibleForProBonusPlay)

            return Prompt(
                coachID: targetPlayerID.coachID,
                payload: .blockActionEligibleForProBonusPlay(
                    playerID: targetPlayerID
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
            !actionContext.history.contains(.eligibleForAbsoluteCarnageBonusPlay)
        {
            history.append(.eligibleForAbsoluteCarnageBonusPlay)
            return Prompt(
                coachID: actionContext.coachID,
                payload: .blockActionEligibleForAbsoluteCarnageBonusPlay(
                    playerID: actionContext.playerID
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
                )
            {
                history.append(.armourResultEligibleForRawTalentBonusPlayReroll)
                return Prompt(
                    coachID: targetPlayerID.coachID,
                    payload: .blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
                        playerID: targetPlayerID,
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
