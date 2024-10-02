//
//  TrapdoorRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

public protocol TrapdoorRandomizing {
    func selectRandomTrapdoor(from squares: Set<Square>) -> Square
}

public final class DefaultTrapdoorRandomizer {
    public init() { }
}

extension DefaultTrapdoorRandomizer: TrapdoorRandomizing {

    public func selectRandomTrapdoor(from squares: Set<Square>) -> Square {
        guard let square = squares.randomElement() else {
            fatalError("No trapdoor squares")
        }
        return square
    }
}
