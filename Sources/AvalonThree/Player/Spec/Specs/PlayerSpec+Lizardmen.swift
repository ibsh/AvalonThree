//
//  PlayerSpec+Lizardmen.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var lizardmen_skinkRunner: PlayerSpec {
        PlayerSpec(
            move: .fixed(8),
            block: 1,
            pass: 4,
            armour: 6,
            skills: [.safeHands]
        )
    }

    static var lizardmen_chameleonSkinkCatcher: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 3,
            armour: 5,
            skills: [.catchersInstincts]
        )
    }

    static var lizardmen_saurusBlocker: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 2,
            pass: 6,
            armour: 2,
            skills: []
        )
    }
}
