//
//  PlayerSpec+Undead.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var undead_skeleton: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 6,
            armour: 4,
            skills: [.regenerate]
        )
    }

    static var undead_zombie: PlayerSpec {
        PlayerSpec(
            move: .fixed(4),
            block: 1,
            pass: 6,
            armour: 3,
            skills: []
        )
    }

    static var undead_ghoul: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 4,
            skills: [.safeHands]
        )
    }

    static var undead_wight: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 5,
            armour: 3,
            skills: [.offensiveSpecialist]
        )
    }

    static var undead_mummy: PlayerSpec {
        PlayerSpec(
            move: .fixed(3),
            block: 2,
            pass: 6,
            armour: 2,
            skills: [.mightyBlow]
        )
    }
}
