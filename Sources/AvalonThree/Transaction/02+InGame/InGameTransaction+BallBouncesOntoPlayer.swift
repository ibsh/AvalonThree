//
//  InGameTransaction+BallBouncesOntoPlayer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func ballBouncesOntoPlayer(
        ballID: BallID,
        playerID: PlayerID
    ) throws {

        guard let ball = table.getBall(id: ballID) else {
            throw GameError("No ball")
        }

        guard case .loose(let ballSquare) = ball.state else {
            throw GameError("Ball is not loose")
        }

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        switch player.state {

        case .inReserves:
            throw GameError("Ball can't bounce onto player in reserves")

        case .prone(let square):
            guard ballSquare == square else {
                throw GameError("Ball can't bounce onto player without square")
            }
            try bounceBall(id: ball.id)
            return

        case .standing(let square):
            guard ballSquare == square else {
                throw GameError("Ball can't bounce onto player in another square")
            }

            if table.playerHasABall(player) != nil || player.spec.pass == nil {
                try bounceBall(id: ball.id)
                return
            }

            var ball = ball
            ball.state = .held(playerID: playerID)
            table.balls.update(with: ball)

            events.append(.playerCaughtBouncingBall(playerID: player.id, ballID: ball.id))
        }
    }
}
