//
//  Team+Chaos.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var chaos: Team {
        Team(
            id: .chaos,
            playerSpecIDs: [
                .chaos_beastman,
                .chaos_beastman,
                .chaos_beastman,
                .chaos_beastman,
                .chaos_chosenBlocker,
                .chaos_chosenBlocker,
            ],
            emergencyReserves: 4
        )
    }
}
