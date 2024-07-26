//
//  PlayerSpec+Necromantic.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var necromantic_zombie: PlayerSpec {
        PlayerSpec(
            move: .fixed(4),
            block: 1,
            pass: 6,
            armour: 3,
            skills: []
        )
    }

    static var necromantic_ghoul: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 4,
            skills: [.safeHands]
        )
    }

    static var necromantic_wraith: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: nil,
            armour: 3,
            skills: [.ethereal]
        )
    }

    static var necromantic_werewolf: PlayerSpec {
        PlayerSpec(
            move: .fixed(8),
            block: 1,
            pass: 4,
            armour: 3,
            skills: [.claws]
        )
    }

    static var necromantic_fleshGolem: PlayerSpec {
        PlayerSpec(
            move: .fixed(4),
            block: 2,
            pass: 6,
            armour: 2,
            skills: []
        )
    }
}
