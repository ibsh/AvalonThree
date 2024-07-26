//
//  Team+Khorne.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var khorne: Team {
        Team(
            id: .khorne,
            playerSpecIDs: [
                .khorne_marauder,
                .khorne_marauder,
                .khorne_marauder,
                .khorne_khorngor,
                .khorne_bloodseeker,
                .khorne_bloodseeker,
            ],
            emergencyReserves: 4
        )
    }
}
