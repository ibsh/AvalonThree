//
//  Team+Ogre.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var ogre: Team {
        Team(
            id: .ogre,
            playerSpecIDs: [
                .ogre_ogre,
                .ogre_ogre,
                .ogre_gnoblar,
                .ogre_gnoblar,
                .ogre_gnoblar,
                .ogre_gnoblar,
                .ogre_gnoblar,
                .ogre_gnoblar,
            ],
            emergencyReserves: 5
        )
    }
}
