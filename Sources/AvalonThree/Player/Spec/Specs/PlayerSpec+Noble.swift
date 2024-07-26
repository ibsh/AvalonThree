//
//  PlayerSpec+Noble.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var noble_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 4,
            skills: []
        )
    }

    static var noble_passer: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 3,
            armour: 4,
            skills: [.handlingSkills]
        )
    }

    static var noble_guard: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 5,
            armour: 3,
            skills: [.standFirm]
        )
    }

    static var noble_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 3,
            skills: [.offensiveSpecialist]
        )
    }
}
