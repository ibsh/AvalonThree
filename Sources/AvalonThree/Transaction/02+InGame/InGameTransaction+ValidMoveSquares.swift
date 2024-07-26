//
//  InGameTransaction+ValidMoveSquares.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/15/24.
//

import Foundation

enum ValidMoveSquareReason {
    case run
    case mark(targetSquares: Set<Square>?)
    case sidestep
}

extension InGameTransaction {

    func validMoveSquares(
        playerID: PlayerID,
        playerSquare: Square,
        moveReason: ValidMoveSquareReason,
        maxDistance: Int
    ) throws -> ValidMoveSquares {

        var validIntermediateSquares = Set<Square>()
        var validFinalSquares = Set<Square>()

        switch moveReason {

        case .run:

            let isValid = buildMoveValidationFunction(
                playerID: playerID,
                reason: .run
            )
            try playerSquare
                .naiveNeighbourhood(distance: maxDistance)
                .forEach { finalSquare in
                    if try isValid(finalSquare, false) {
                        validIntermediateSquares.insert(finalSquare)
                    }
                    if finalSquare == playerSquare {
                        if try isValid(finalSquare, true) {
                            validFinalSquares.insert(finalSquare)
                        }
                    } else if
                        let path = try Square.optimalPath(
                            from: playerSquare,
                            to: finalSquare,
                            isValid: isValid
                        ),
                        path.count <= maxDistance
                    {
                        validFinalSquares.insert(finalSquare)
                    }
                }

        case .sidestep:

            validFinalSquares = try playerSquare
                .adjacentSquares
                .filter { destination in
                    switch try playerCanMoveIntoSquare(
                        playerID: playerID,
                        newSquare: destination,
                        isFinalSquare: true,
                        reason: .sidestep
                    ) {
                    case .canMove:
                        return true
                    case .cannotMove:
                        return false
                    }
                }
                .toSet()

        case .mark(let targetSquares):

            let isValid = buildMoveValidationFunction(
                playerID: playerID,
                reason: .mark
            )
            try playerSquare
                .naiveNeighbourhood(distance: maxDistance)
                .forEach { finalSquare in
                    if try isValid(finalSquare, false) {
                        validIntermediateSquares.insert(finalSquare)
                    }
                    if let targetSquares, !targetSquares.contains(finalSquare) { return }
                    if finalSquare == playerSquare {
                        if try isValid(finalSquare, true) {
                            validFinalSquares.insert(finalSquare)
                        }
                    } else if
                        let path = try Square.optimalPath(
                            from: playerSquare,
                            to: finalSquare,
                            isValid: isValid
                        ),
                        path.count <= maxDistance
                    {
                        validFinalSquares.insert(finalSquare)
                    }
                }
        }

        return ValidMoveSquares(
            intermediate: validIntermediateSquares,
            final: validFinalSquares
        )
    }
}
