//
//  InGameTransaction+InputMessage+Action+Mark+SelectSquares.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func markActionSelectSquares(
        squares: [Square]
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()
        
        guard
            let actionContext = try turnContext.actionContexts().last,
            !actionContext.isFinished,
            let (maxMarkDistance, validSquares) = actionContext.history.lastResult(
                { entry -> (Int, ValidMoveSquares)? in
                    guard case .markValidSquares(
                        let maxMarkDistance,
                        let validSquares
                    ) = entry else {
                        return nil
                    }
                    return (maxMarkDistance, validSquares)
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

        guard squares.count <= maxMarkDistance else {
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

        if
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .markHasRequiredTargetPlayer(let targetPlayerID) = entry else {
                        return nil
                    }
                    return targetPlayerID
                }
            )
        {
            guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
                throw GameError("No target player")
            }
            guard let targetPlayerSquare = targetPlayer.square else {
                throw GameError("No target square")
            }
            guard finalSquare.isAdjacent(to: targetPlayerSquare) else {
                throw GameError("Mark does not end next to required target")
            }
        }

        try squares.enumerated().forEach { index, square in
            try playerMovesIntoSquare(
                playerID: player.id,
                newSquare: square,
                isFinalSquare: index == squares.indices.last,
                reason: .mark
            )
        }

        // finish the action
        history.append(.actionFinished)

        return try endAction()
    }
}
