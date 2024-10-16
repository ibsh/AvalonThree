//
//  Player.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

struct Player: Codable {
    let id: PlayerID
    let spec: PlayerSpec
    var state: State
    var canTakeActions: Bool
}

public struct PlayerID: Hashable, Codable, Sendable {
    public let coachID: CoachID
    public let index: Int
}

extension Player {
    enum State: Codable {
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
