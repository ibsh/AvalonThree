//
//  Team+Halfling.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var halfling: Team {
        Team(
            id: .halfling,
            playerSpecIDs: [
                .halfling_hopeful,
                .halfling_hopeful,
                .halfling_hopeful,
                .halfling_hopeful,
                .halfling_catcher,
                .halfling_hefty,
                .halfling_treeman,
            ],
            emergencyReserves: 2
        )
    }
}
