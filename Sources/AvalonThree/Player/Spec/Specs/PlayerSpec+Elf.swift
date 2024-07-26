//
//  PlayerSpec+Elf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var elf_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 4,
            skills: []
        )
    }

    static var elf_passer: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 2,
            armour: 4,
            skills: [.handlingSkills]
        )
    }

    static var elf_catcher: PlayerSpec {
        PlayerSpec(
            move: .fixed(8),
            block: 1,
            pass: 4,
            armour: 5,
            skills: [.catchersInstincts]
        )
    }

    static var elf_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 3,
            armour: 3,
            skills: [.offensiveSpecialist]
        )
    }
}
