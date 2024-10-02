//
//  InGameTransaction+InputMessage+Action+Block+ResolveFollowUp.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseFollowUp() throws -> Prompt? {
        return try blockActionResolveFollowUp(followUp: true)
    }

    mutating func blockActionDeclineFollowUp() throws -> Prompt? {
        return try blockActionResolveFollowUp(followUp: false)
    }

    private mutating func blockActionResolveFollowUp(
        followUp: Bool
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let newSquare = actionContext.history.lastResult(
                { entry -> Square? in
                    guard case .blockFollowUpSquare(let square) = entry else { return nil }
                    return square
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        if followUp {
            try playerMovesIntoSquare(
                playerID: actionContext.playerID,
                newSquare: newSquare,
                isFinalSquare: true,
                reason: .followUp
            )
        } else {
            events.append(
                .declinedFollowUp(
                    playerID: actionContext.playerID,
                    playerSquare: playerSquare
                )
            )
        }

        return try endBlockAction()
    }
}
