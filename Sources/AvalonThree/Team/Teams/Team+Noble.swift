//
//  Team+Noble.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var noble: Team {
        Team(
            id: .noble,
            playerSpecIDs: [
                .noble_lineman,
                .noble_lineman,
                .noble_passer,
                .noble_guard,
                .noble_guard,
                .noble_blitzer,
            ],
            emergencyReserves: 4
        )
    }
}
