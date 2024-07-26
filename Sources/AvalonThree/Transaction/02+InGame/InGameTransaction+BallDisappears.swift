//
//  InGameTransaction+BallDisappears.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func ballDisappears(
        id ballID: BallID
    ) throws {

        guard let ball = table.getBall(id: ballID) else {
            throw GameError("No ball")
        }

        table.balls.remove(ball)

        switch ball.state {
        case .held:
            events.append(.ballCameLoose(ballID: ballID))
        case .loose:
            break
        }

        events.append(.ballDisappeared(ballID: ballID))
    }
}
