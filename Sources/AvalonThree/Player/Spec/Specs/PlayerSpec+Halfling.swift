//
//  PlayerSpec+Halfling.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var halfling_hopeful: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 4,
            armour: 6,
            skills: []
        )
    }

    static var halfling_catcher: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 4,
            armour: 6,
            skills: [.catchersInstincts]
        )
    }

    static var halfling_hefty: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 4,
            armour: 4,
            skills: [.standFirm]
        )
    }

    static var halfling_treeman: PlayerSpec {
        PlayerSpec(
            move: .fixed(2),
            block: 2,
            pass: 5,
            armour: 2,
            skills: [.hulkingBrute, .hurlTeammate]
        )
    }
}
