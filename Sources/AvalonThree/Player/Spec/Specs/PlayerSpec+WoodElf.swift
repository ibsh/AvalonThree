//
//  PlayerSpec+WoodElf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var woodElf_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 5,
            skills: []
        )
    }

    static var woodElf_passer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 2,
            armour: 5,
            skills: [.handlingSkills]
        )
    }

    static var woodElf_catcher: PlayerSpec {
        PlayerSpec(
            move: .fixed(8),
            block: 1,
            pass: 4,
            armour: 6,
            skills: [.catchersInstincts]
        )
    }

    static var woodElf_wardancer: PlayerSpec {
        PlayerSpec(
            move: .fixed(8),
            block: 1,
            pass: 4,
            armour: 5,
            skills: [.rush]
        )
    }
}
