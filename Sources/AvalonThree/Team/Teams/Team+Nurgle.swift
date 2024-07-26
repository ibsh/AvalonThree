//
//  Team+Nurgle.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var nurgle: Team {
        Team(
            id: .nurgle,
            playerSpecIDs: [
                .nurgle_lineman,
                .nurgle_lineman,
                .nurgle_lineman,
                .nurgle_pestigor,
                .nurgle_bloater,
                .nurgle_bloater,
            ],
            emergencyReserves: 4
        )
    }
}
