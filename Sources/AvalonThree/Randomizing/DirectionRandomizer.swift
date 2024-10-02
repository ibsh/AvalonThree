//
//  DirectionRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

public protocol DirectionRandomizing {
    func rollForDirection() -> Direction
}

public final class DefaultDirectionRandomizer {
    public init() { }
}

extension DefaultDirectionRandomizer: DirectionRandomizing {

    public func rollForDirection() -> Direction {
        guard let direction = Direction.allCases.randomElement() else {
            fatalError("No Direction cases")
        }
        return direction
    }
}
