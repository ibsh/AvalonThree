//
//  Table+Players.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

extension Table {

    func getPlayer(
        id: PlayerID
    ) -> Player? {
        players.first(
            where: { $0.id == id }
        )
    }

    func getPlayer(
        coachID: CoachID,
        playerIndex: Int
    ) -> Player? {
        players.first(
            where: { $0.coachID == coachID && $0.index == playerIndex }
        )
    }

    func playerInSquare(
        _ square: Square
    ) -> Player? {
        players.first(where: { $0.square == square })
    }

    func playersInSquares(
        _ squares: [Square]
    ) -> Set<Player> {
        players.filter { player in
            guard let playerSquare = player.square else { return false }
            return squares.contains(playerSquare)
        }
    }

    func playerIsOpen(
        _ player: Player
    ) -> Square? {
        switch player.state {
        case .inReserves,
             .prone:
            return nil
        case .standing(let square):
            return standingOpponentsAdjacentToSquare(square, for: player.id).isEmpty ? square : nil
        }
    }

    func playerIsMarked(
        _ player: Player
    ) -> Square? {
        switch player.state {
        case .inReserves,
             .prone:
            return nil
        case .standing(let square):
            return standingOpponentsAdjacentToSquare(square, for: player.id).isEmpty ? nil : square
        }
    }

    func playerIsProne(
        _ player: Player
    ) -> Square? {
        switch player.state {
        case .inReserves,
             .standing:
            return nil
        case .prone(let square):
            return square
        }
    }
}
