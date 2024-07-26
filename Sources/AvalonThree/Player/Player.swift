//
//  Player.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

struct Player {
    let id: PlayerID
    let spec: PlayerSpec
    var state: State
    var canTakeActions: Bool
}

public struct PlayerID: Hashable, Codable {
    let coachID: CoachID
    let index: Int
}

public struct PlayerConfig: Hashable, Codable {
    let id: PlayerID
    let specID: PlayerSpecID
}

extension Player {
    enum State {
        case inReserves
        case standing(square: Square)
        case prone(square: Square)
    }
}

extension Player {

    var coachID: CoachID {
        id.coachID
    }

    var index: Int {
        id.index
    }
}

extension Player: Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}

extension Player: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
