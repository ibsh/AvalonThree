//
//  InGameTransaction+InputMessage+Action+Run+SelectSquares.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func runActionSelectSquares(
        squares: [Square]
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let (maxRunDistance, validSquares) = actionContext.history.lastResult(
                { entry -> (Int, ValidMoveSquares)? in
                    guard
                        case .runValidSquares(
                            let maxRunDistance,
                            let validSquares
                        ) = entry
                    else { return nil }
                    return (maxRunDistance, validSquares)
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let finalSquare = squares.last else {
            throw GameError("No squares")
        }

        guard squares.count <= maxRunDistance else {
            throw GameError("Too many squares")
        }

        for intermediateSquare in squares.dropLast() {
            guard validSquares.intermediate.contains(intermediateSquare) else {
                throw GameError("Invalid intermediate square")
            }
        }

        guard validSquares.final.contains(finalSquare) else {
            throw GameError("Invalid final square")
        }

        try squares.enumerated().forEach { index, square in
            try playerMovesIntoSquare(
                playerID: player.id,
                newSquare: square,
                isFinalSquare: index == squares.indices.last,
                reason: .run
            )
        }

        // finish the action
        history.append(.actionFinished)
        return try endAction()
    }
}
