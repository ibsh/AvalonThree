//
//  InGameTransaction+InputMessage+Action+HurlTeammate+RollDie.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func hurlTeammateActionRollDie() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let target = actionContext.history.lastResult(
                { entry -> HurlTeammateTarget? in
                    guard case .hurlTeammateTarget(let target) = entry else { return nil }
                    return target
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard var effectivePassStat = player.spec.pass else {
            throw GameError("Player has no pass stat")
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .pro }
            ),
            !actionContext.history.contains(.hurlTeammateActionEligibleForProBonusPlay)
        {
            history.append(.hurlTeammateActionEligibleForProBonusPlay)

            return Prompt(
                coachID: actionContext.coachID,
                payload: .hurlTeammateActionEligibleForProBonusPlay(
                    playerID: actionContext.playerID
                )
            )
        }

        if table.getActiveBonuses(coachID: actionContext.coachID).contains(
            where: { $0.bonusPlay == .accuratePass }
        ) {
            effectivePassStat = 2
        }

        var modifier = 0
        var modifications = [HurlTeammateRollModification]()

        switch target.distance {
        case .handoff,
             .short:
            break
        case .long:
            modifier -= 1
            modifications.append(.longDistance)
        }

        if !target.obstructingSquares.isEmpty {
            modifier -= 1
            modifications.append(.obstructed)
        }

        modifier = max(-1, modifier)

        let randomizer: DXRandomizing = {
            let bonusPlays: Set<BonusPlay> = [.passingPlay, .pro]
            if table.getActiveBonuses(
                coachID: actionContext.coachID
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
            .rolledForHurlTeammate(
                coachID: actionContext.coachID,
                die: randomizer.die,
                unmodified: unmodifiedRoll
            )
        )

        let modifiedRoll: Int

        if unmodifiedRoll >= TableConstants.rollOfSix || modifier == 0 {
            modifiedRoll = unmodifiedRoll
        } else {
            modifiedRoll = (unmodifiedRoll + modifier).clamp(randomizer.range)
            events.append(
                .changedHurlTeammateResult(
                    die: randomizer.die,
                    unmodified: unmodifiedRoll,
                    modified: modifiedRoll,
                    modifications: modifications
                )
            )
        }

        if modifier < 0 {
            history.append(.hurlTeammateNegativeModifier)
        }

        history.append(
            .hurlTeammateRolled(
                effectivePassStat: effectivePassStat,
                unmodifiedRoll: unmodifiedRoll,
                modifiedRoll: modifiedRoll
            )
        )

        if
            !actionContext.history.contains(.hurlTeammateResultEligibleForRawTalentBonusPlayReroll),
            table.getHand(coachID: player.coachID).contains(where: { $0.bonusPlay == .rawTalent })
        {
            history.append(.hurlTeammateResultEligibleForRawTalentBonusPlayReroll)

            return Prompt(
                coachID: player.coachID,
                payload: .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
                    playerID: player.id,
                    result: modifiedRoll
                )
            )
        }

        return try resolveHurlTeammateAction()
    }
}
