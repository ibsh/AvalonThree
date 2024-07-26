//
//  TrapdoorRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

protocol TrapdoorRandomizing {
    func selectRandomTrapdoor(from squares: Set<Square>) -> Square
}

struct DefaultTrapdoorRandomizer: TrapdoorRandomizing {
    func selectRandomTrapdoor(from squares: Set<Square>) -> Square {
        guard let square = squares.randomElement() else {
            fatalError("No trapdoor squares")
        }
        return square
    }
}
