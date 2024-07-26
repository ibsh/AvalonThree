//
//  Ball.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

public typealias BallID = UUID

struct Ball {
    public let id: BallID
    public var state: State
}

extension Ball {
    enum State {
        case held(playerID: PlayerID)
        case loose(square: Square)
    }
}

extension Ball {
    init(
        idProvider: UUIDProviding,
        state: State
    ) {
        id = idProvider.generate()
        self.state = state
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
