//
//  InGameTransaction+InputMessage+Action+Sidestep+SelectSquare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func sidestepActionSelectSquare(
        square: Square
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let validSquares = actionContext.history.lastResult(
                { entry -> ValidMoveSquares? in
                    guard case .sidestepValidSquares(let validSquares) = entry else { return nil }
                    return validSquares
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard validSquares.final.contains(square) else {
            throw GameError("Invalid squares")
        }

        try playerMovesIntoSquare(
            playerID: player.id,
            newSquare: square,
            isFinalSquare: true,
            reason: .sidestep
        )

        // finish the action
        history.append(.actionFinished)
        return try endAction()
    }
}
