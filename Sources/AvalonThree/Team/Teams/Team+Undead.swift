//
//  Team+Undead.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var undead: Team {
        Team(
            id: .undead,
            playerSpecIDs: [
                .undead_skeleton,
                .undead_skeleton,
                .undead_zombie,
                .undead_zombie,
                .undead_ghoul,
                .undead_wight,
                .undead_mummy,
            ],
            emergencyReserves: 4
        )
    }
}
