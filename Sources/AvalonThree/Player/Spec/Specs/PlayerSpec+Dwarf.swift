//
//  PlayerSpec+Dwarf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var dwarf_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(4),
            block: 1,
            pass: 5,
            armour: 2,
            skills: []
        )
    }

    static var dwarf_runner: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 3,
            skills: [.safeHands]
        )
    }

    static var dwarf_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 4,
            armour: 2,
            skills: [.offensiveSpecialist]
        )
    }

    static var dwarf_trollslayer: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 6,
            armour: 4,
            skills: [.frenzied]
        )
    }
}
