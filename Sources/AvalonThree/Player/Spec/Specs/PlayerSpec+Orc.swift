//
//  PlayerSpec+Orc.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var orc_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 4,
            armour: 2,
            skills: []
        )
    }

    static var orc_passer: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 3,
            armour: 3,
            skills: [.handlingSkills]
        )
    }

    static var orc_blitzer: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 2,
            skills: [.offensiveSpecialist]
        )
    }

    static var orc_bigUnBlocker: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 2,
            pass: 6,
            armour: 2,
            skills: []
        )
    }
}
