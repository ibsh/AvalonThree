//
//  Team+Goblin.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var goblin: Team {
        Team(
            id: .goblin,
            playerSpecIDs: [
                .goblin_goblin,
                .goblin_goblin,
                .goblin_goblin,
                .goblin_goblin,
                .goblin_goblin,
                .goblin_goblin,
                .goblin_troll,
            ],
            emergencyReserves: 4
        )
    }
}
