//
//  Team+Lizardmen.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var lizardmen: Team {
        Team(
            id: .lizardmen,
            playerSpecIDs: [
                .lizardmen_skinkRunner,
                .lizardmen_skinkRunner,
                .lizardmen_chameleonSkinkCatcher,
                .lizardmen_saurusBlocker,
                .lizardmen_saurusBlocker,
                .lizardmen_saurusBlocker,
            ],
            emergencyReserves: 4
        )
    }
}
