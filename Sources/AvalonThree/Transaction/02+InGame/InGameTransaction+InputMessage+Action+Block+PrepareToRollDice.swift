//
//  InGameTransaction+InputMessage+Action+Block+PrepareToRollDice.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionPrepareToRollDice() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        if
            table.getHand(coachID: targetPlayerID.coachID).contains(
                where: { $0.bonusPlay == .stepAside}
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForStepAsideBonusPlaySidestepAction
            ),
            try playerCanDeclareAction(
                player: targetPlayer,
                actionID: .sidestep
            ) == .canDeclare(consumesBonusPlays: [])
        {
            history.append(.blockDieResultsEligibleForStepAsideBonusPlaySidestepAction)
            return Prompt(
                coachID: targetPlayerID.coachID,
                payload: .blockActionEligibleForStepAsideBonusPlaySidestepAction(
                    playerID: targetPlayerID
                )
            )
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .bodyCheck}
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForBodyCheckBonusPlay
            )
        {
            history.append(.blockDieResultsEligibleForBodyCheckBonusPlay)
            return Prompt(
                coachID: actionContext.coachID,
                payload: .blockActionEligibleForBodyCheckBonusPlay(
                    playerID: actionContext.playerID
                )
            )
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .theKidsGotMoxy}
            ),
            !actionContext.history.contains(
                .blockAssisted
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForTheKidsGotMoxyBonusPlay
            )
        {
            history.append(.blockDieResultsEligibleForTheKidsGotMoxyBonusPlay)
            return Prompt(
                coachID: actionContext.coachID,
                payload: .blockActionEligibleForTheKidsGotMoxyBonusPlay(
                    playerID: actionContext.playerID
                )
            )
        }

        return try blockActionRollDice()
    }
}
