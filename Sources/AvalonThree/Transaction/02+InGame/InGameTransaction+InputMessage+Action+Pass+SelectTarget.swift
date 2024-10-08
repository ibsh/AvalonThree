//
//  InGameTransaction+InputMessage+Action+Pass+SelectTarget.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionSelectTarget(
        target targetPlayerID: PlayerID
    ) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let actionContext = try turnContext.actionContexts().last,
            !actionContext.isFinished,
            let validTargets = actionContext.history.lastResult(
                { entry -> Set<PassTarget>? in
                    guard case .passValidTargets(let validTargets) = entry else { return nil }
                    return validTargets
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        guard
            let validTarget = validTargets
                .first(where: { $0.targetPlayerID == targetPlayerID })
        else {
            throw GameError("Invalid target player")
        }

        history.append(.passTarget(validTarget))

        let bonusPlay = BonusPlay.accuratePass

        if
            table
                .getHand(coachID: actionContext.coachID)
                .contains(where: { $0.bonusPlay == bonusPlay }),
            validTarget.distance == .short,
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: bonusPlay)
            )
        {
            return Prompt(
                coachID: actionContext.coachID,
                payload: .passActionEligibleForAccuratePassBonusPlay(
                    playerID: actionContext.playerID,
                    playerSquare: playerSquare
                )
            )
        }

        return try passActionRollDie()
    }
}
