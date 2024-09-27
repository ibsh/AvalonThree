//
//  InGameTransaction+BounceBall.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func bounceBall(
        id ballID: Int
    ) throws {

        let turnContext = try history.latestTurnContext()

        let direction = randomizers.direction.rollForDirection()
        events.append(
            .rolledForDirection(coachID: turnContext.coachID, direction: direction)
        )

        try bounceBall(id: ballID, direction: direction)
    }

    mutating func bounceBall(
        id ballID: Int,
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
            let oldDirection = direction
            if let validSquare = square.inDirection(direction) {
                if table.boardSpecID.spec.obstructedSquares.contains(validSquare) {
                    direction = direction.nextClockwise
                    events.append(.changedDirection(from: oldDirection, to: direction))
                } else {
                    newSquare = validSquare
                    break
                }
            } else {
                direction = direction.nextClockwise
                events.append(.changedDirection(from: oldDirection, to: direction))
            }
        }

        ball.state = .loose(square: newSquare)
        table.balls.update(with: ball)

        guard let direction = square.direction(to: newSquare) else {
            throw GameError("No direction")
        }

        events.append(
            .ballBounced(ballID: ball.id, from: square, to: newSquare, direction: direction)
        )

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
