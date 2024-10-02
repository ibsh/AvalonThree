//
//  InGameTransaction+BallComesLoose.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func ballComesLoose(
        id ballID: Int,
        square: Square
    ) throws {

        guard var ball = table.getBall(id: ballID) else {
            throw GameError("No ball")
        }

        ball.state = .loose(square: square)
        table.balls.update(with: ball)

        events.append(.ballCameLoose(ballID: ballID, ballSquare: square))
    }
}
