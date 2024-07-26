//
//  PlayerSpec+Skaven.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var skaven_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 4,
            skills: []
        )
    }

    static var skaven_passer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 3,
            armour: 4,
            skills: [.handlingSkills]
        )
    }

    static var skaven_gutterRunner: PlayerSpec {
        PlayerSpec(
            move: .fixed(9),
            block: 1,
            pass: 4,
            armour: 5,
            skills: [.safeHands]
        )
    }

    static var skaven_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 5,
            armour: 3,
            skills: [.offensiveSpecialist]
        )
    }
}
