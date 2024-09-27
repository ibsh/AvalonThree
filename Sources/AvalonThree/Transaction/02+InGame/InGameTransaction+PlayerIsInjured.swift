//
//  InGameTransaction+PlayerIsInjured.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func playerIsInjured(
        playerID: PlayerID,
        reason: PlayerInjuryReason
    ) throws {

        guard var player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        player.state = .inReserves
        table.players.update(with: player)

        history.append(.playerInjured(playerID))
        events.append(
            .playerInjured(playerID: playerID, in: playerSquare, reason: reason)
        )

        switch reason {
        case .blocked,
             .fouled,
             .fumbled:
            if let ball = table.playerHasABall(player) {
                try ballComesLoose(id: ball.id, square: playerSquare)
                try bounceBall(id: ball.id)
            }
        case .trapdoor:
            if let ball = table.playerHasABall(player) {
                try ballDisappears(id: ball.id, in: playerSquare)
            }
        }
    }
}
