//
//  Ball.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

struct Ball {
    public let id: Int
    public var state: State
}

extension Ball {
    enum State {
        case held(playerID: PlayerID)
        case loose(square: Square)
    }
}

extension Ball: Equatable {
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        lhs.id == rhs.id
    }
}

extension Ball: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
