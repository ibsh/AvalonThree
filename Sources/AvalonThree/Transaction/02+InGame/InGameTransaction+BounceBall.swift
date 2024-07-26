//
//  InGameTransaction+BounceBall.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func bounceBall(
        id ballID: BallID
    ) throws {

        let direction = randomizers.direction.rollForDirection()
        events.append(.rolledForDirection(direction: direction))

        try bounceBall(id: ballID, direction: direction)
    }

    mutating func bounceBall(
        id ballID: BallID,
        direction: Direction
    ) throws {

        guard var ball = table.getBall(id: ballID) else {
            throw GameError("No ball")
        }

        guard case .loose(let square) = ball.state else {
            throw GameError("No square")
        }

        var direction = direction

        var newSquare: Square!
        while true {
            if let validSquare = square.inDirection(direction) {
                if table.boardSpecID.spec.obstructedSquares.contains(validSquare) {
                    direction = direction.nextClockwise
                    events.append(.changedDirection(direction: direction))
                } else {
                    newSquare = validSquare
                    break
                }
            } else {
                direction = direction.nextClockwise
                events.append(.changedDirection(direction: direction))
            }
        }

        ball.state = .loose(square: newSquare)
        table.balls.update(with: ball)

        events.append(.ballBounced(ballID: ball.id, to: newSquare))

        if table.looseBalls(in: newSquare).count > 1 {
            try bounceBall(id: ball.id)
            return
        }

        if let player = table.playerInSquare(newSquare) {
            try ballBouncesOntoPlayer(
                ballID: ballID,
                playerID: player.id
            )
        }
    }
}
