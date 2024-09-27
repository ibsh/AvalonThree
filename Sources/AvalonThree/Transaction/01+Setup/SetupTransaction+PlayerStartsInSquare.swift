//
//  SetupTransaction+PlayerStartsInSquare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension SetupTransaction {

    mutating func playerStartsInSquare(
        playerID: PlayerID,
        square: Square
    ) throws {

        guard var player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard player.isInReserves else {
            throw GameError("Player is not in reserves")
        }

        guard table.squareIsUnobstructed(square) else {
            throw GameError("New square is obstructed")
        }

        guard table.squareIsEmptyOfPlayers(square) else {
            throw GameError("New square is not empty")
        }

        player.state = .standing(square: square)
        table.players.update(with: player)

        events.append(
            .playerMovedOutOfReserves(playerID: playerID, to: square)
        )
    }
}
