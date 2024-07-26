//
//  PlayerSpec+Ogre.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var ogre_ogre: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 2,
            pass: 5,
            armour: 2,
            skills: [.hulkingBrute, .hurlTeammate]
        )
    }

    static var ogre_gnoblar: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 5,
            armour: 6,
            skills: [.titchy]
        )
    }
}
