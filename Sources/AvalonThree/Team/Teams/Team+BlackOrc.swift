//
//  Team+BlackOrc.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var blackOrc: Team {
        Team(
            id: .blackOrc,
            playerSpecIDs: [
                .blackOrc_blackOrc,
                .blackOrc_blackOrc,
                .blackOrc_blackOrc,
                .blackOrc_goblin,
                .blackOrc_goblin,
                .blackOrc_goblin,
            ],
            emergencyReserves: 4
        )
    }
}
