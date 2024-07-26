//
//  Team+Skaven.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var skaven: Team {
        Team(
            id: .skaven,
            playerSpecIDs: [
                .skaven_lineman,
                .skaven_lineman,
                .skaven_lineman,
                .skaven_passer,
                .skaven_gutterRunner,
                .skaven_blitzer,
            ],
            emergencyReserves: 4
        )
    }
}
