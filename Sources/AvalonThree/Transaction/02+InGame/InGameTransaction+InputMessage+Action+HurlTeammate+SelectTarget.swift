//
//  InGameTransaction+InputMessage+Action+HurlTeammate+SelectTarget.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func hurlTeammateActionSelectTarget(
        targetSquare: Square
    ) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let actionContext = try turnContext.actionContexts().last,
            !actionContext.isFinished,
            let validTargets = actionContext.history.lastResult(
                { entry -> Set<HurlTeammateTarget>? in
                    guard case .hurlTeammateValidTargets(let validTargets) = entry else {
                        return nil
                    }
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
                .first(where: { $0.targetSquare == targetSquare })
        else {
            throw GameError("Invalid target")
        }

        history.append(.hurlTeammateTarget(validTarget))

        if table
            .getHand(coachID: turnContext.coachID)
            .contains(where: { $0.bonusPlay == .accuratePass }),
           !turnContext.history.contains(
            .usedBonusPlay(coachID: turnContext.coachID, bonusPlay: .rawTalent)
           ),
           validTarget.distance == .short
        {

            return Prompt(
                coachID: turnContext.coachID,
                payload: .hurlTeammateActionEligibleForAccuratePassBonusPlay(
                    playerID: actionContext.playerID,
                    playerSquare: playerSquare
                )
            )
        }

        return try hurlTeammateActionRollDie()
    }
}
