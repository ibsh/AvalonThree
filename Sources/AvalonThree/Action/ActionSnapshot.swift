//
//  ActionSnapshot.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/6/24.
//

import Foundation

struct ActionSnapshot: Codable, Equatable {
    let balls: Set<Ball>
    let players: Set<Player>
}

extension ActionSnapshot {
    init(table: Table) {
        self.balls = table.balls
        self.players = table.players
    }
}
