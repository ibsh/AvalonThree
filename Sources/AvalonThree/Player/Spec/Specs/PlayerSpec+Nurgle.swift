//
//  PlayerSpec+Nurgle.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var nurgle_lineman: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 6,
            armour: 4,
            skills: []
        )
    }

    static var nurgle_pestigor: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 3,
            skills: [.headbutt]
        )
    }

    static var nurgle_bloater: PlayerSpec {
        PlayerSpec(
            move: .fixed(4),
            block: 2,
            pass: 6,
            armour: 3,
            skills: [.standFirm]
        )
    }
}
