//
//  InGameTransaction+InputMessage+Action+Block+End.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/10/24.
//

import Foundation

extension InGameTransaction {

    mutating func endBlockAction() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        if actionContext.history.contains(.blockIsDivingTackle) {
            guard var player = table.getPlayer(id: actionContext.playerID) else {
                throw GameError("No player")
            }

            guard let playerSquare = player.isStanding else {
                throw GameError("Player is not standing")
            }

            player.state = .prone(square: playerSquare)
            table.players.update(with: player)

            events.append(
                .playerFellDown(playerID: player.id, in: playerSquare, reason: .divingTackle)
            )

            if let ball = table.playerHasABall(player) {
                try ballComesLoose(id: ball.id, square: playerSquare)
                try bounceBall(id: ball.id)
            }
        }

        // finish the action
        history.append(.actionFinished)
        return try endAction()
    }
}
