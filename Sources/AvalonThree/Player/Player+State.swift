//
//  Player+State.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

extension Player {

    var square: Square? {
        switch state {
        case .inReserves:
            nil
        case .standing(let square),
             .prone(let square):
            square
        }
    }

    var isProne: Square? {
        switch state {
        case .inReserves,
             .standing:
            nil
        case .prone(let square):
            square
        }
    }

    var isStanding: Square? {
        switch state {
        case .inReserves,
             .prone:
            nil
        case .standing(let square):
            square
        }
    }

    var isInReserves: Bool {
        square == nil
    }
}
