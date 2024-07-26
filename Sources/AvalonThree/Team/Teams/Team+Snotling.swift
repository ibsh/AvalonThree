//
//  Team+Snotling.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var snotling: Team {
        Team(
            id: .snotling,
            playerSpecIDs: [
                .snotling_snotling,
                .snotling_snotling,
                .snotling_snotling,
                .snotling_snotling,
                .snotling_snotling,
                .snotling_snotling,
                .snotling_fungusFlinga,
                .snotling_funHoppa,
                .snotling_stiltyRunna,
                .snotling_pumpWagon,
            ],
            emergencyReserves: 6
        )
    }
}
