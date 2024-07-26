//
//  PlayerSpec+DarkElf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var darkElf_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 3,
            skills: []
        )
    }

    static var darkElf_runner: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 3,
            armour: 4,
            skills: [.safeHands]
        )
    }

    static var darkElf_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 4,
            armour: 3,
            skills: [.offensiveSpecialist]
        )
    }

    static var darkElf_witchElf: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 5,
            armour: 4,
            skills: [.frenzied]
        )
    }
}
