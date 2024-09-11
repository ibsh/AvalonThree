//
//  DirectionRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

protocol DirectionRandomizing: Sendable {
    func rollForDirection() -> Direction
}

struct DefaultDirectionRandomizer: DirectionRandomizing {
    func rollForDirection() -> Direction {
        guard let direction = Direction.allCases.randomElement() else {
            fatalError("No Direction cases")
        }
        return direction
    }
}
