//
//  Team+Orc.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var orc: Team {
        Team(
            id: .orc,
            playerSpecIDs: [
                .orc_lineman,
                .orc_lineman,
                .orc_lineman,
                .orc_passer,
                .orc_blitzer,
                .orc_bigUnBlocker,
            ],
            emergencyReserves: 4
        )
    }
}
