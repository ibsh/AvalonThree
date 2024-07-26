//
//  InGameTransaction+InputMessage+Action+Pass+SpecifyTarget.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionSpecifyTarget(
        target targetPlayerID: PlayerID
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
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

        guard
            let validTarget = validTargets
                .first(where: { $0.targetPlayerID == targetPlayerID })
        else {
            throw GameError("Invalid target player")
        }

        history.append(.passTarget(validTarget))

        if
            table
                .getHand(coachID: actionContext.coachID)
                .contains(where: { $0.bonusPlay == .accuratePass }),
            validTarget.distance == .short
        {
            return Prompt(
                coachID: actionContext.coachID,
                payload: .passActionEligibleForAccuratePassBonusPlay(
                    playerID: actionContext.playerID
                )
            )
        }

        return try passActionRollDie()
    }
}
