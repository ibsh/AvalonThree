//
//  Team+Human.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var human: Team {
        Team(
            id: .human,
            playerSpecIDs: [
                .human_lineman,
                .human_lineman,
                .human_lineman,
                .human_passer,
                .human_catcher,
                .human_blitzer,
            ],
            emergencyReserves: 4
        )
    }
}
