//
//  PlayerSpec+Move.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Foundation

extension PlayerSpec {
    enum Move: Equatable {
        case fixed(Int)
        case random(RandomDistance)
    }
}

extension PlayerSpec.Move {
    enum RandomDistance {
        case d6
    }
}
