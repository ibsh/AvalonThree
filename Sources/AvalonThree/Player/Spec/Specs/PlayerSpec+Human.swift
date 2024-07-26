//
//  PlayerSpec+Human.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var human_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 3,
            skills: []
        )
    }

    static var human_passer: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 3,
            armour: 3,
            skills: [.handlingSkills]
        )
    }

    static var human_catcher: PlayerSpec {
        PlayerSpec(
            move: .fixed(8),
            block: 1,
            pass: 4,
            armour: 5,
            skills: [.catchersInstincts]
        )
    }

    static var human_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 3,
            skills: [.offensiveSpecialist]
        )
    }
}
