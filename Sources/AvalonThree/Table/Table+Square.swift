//
//  Table+Square.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension Table {

    func squareIsUnobstructed(
        _ square: Square
    ) -> Bool {
        !boardSpecID.spec.obstructedSquares.contains(square)
    }

    func squareIsEmptyOfPlayers(
        _ square: Square
    ) -> Bool {
        playerInSquare(square) == nil
    }

    func opponentsAdjacentToSquare(
        _ square: Square,
        for playerID: PlayerID
    ) -> Set<Player> {
        playersInSquares(square.adjacentSquares)
            .filter { adjacentPlayer in
                adjacentPlayer.coachID != playerID.coachID
            }
    }

    func standingOpponentsAdjacentToSquare(
        _ square: Square,
        for playerID: PlayerID
    ) -> Set<Player> {
        playersInSquares(square.adjacentSquares)
            .filter { adjacentPlayer in
                adjacentPlayer.coachID != playerID.coachID
                && adjacentPlayer.isStanding != nil
            }
    }

    func validLooseBallDirections(from square: Square) -> [Direction] {
        Direction.allCases.filter { direction in
            guard let newSquare = square.inDirection(direction) else { return false }
            return squareIsUnobstructed(newSquare)
        }
    }
}
