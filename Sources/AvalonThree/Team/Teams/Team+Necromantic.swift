//
//  Team+Necromantic.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var necromantic: Team {
        Team(
            id: .necromantic,
            playerSpecIDs: [
                .necromantic_zombie,
                .necromantic_zombie,
                .necromantic_zombie,
                .necromantic_ghoul,
                .necromantic_wraith,
                .necromantic_werewolf,
                .necromantic_fleshGolem,
            ],
            emergencyReserves: 5
        )
    }
}
