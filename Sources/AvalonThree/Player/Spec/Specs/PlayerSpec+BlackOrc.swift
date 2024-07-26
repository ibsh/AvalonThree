//
//  PlayerSpec+BlackOrc.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var blackOrc_blackOrc: PlayerSpec {
        PlayerSpec(
            move: .fixed(4),
            block: 2,
            pass: 5,
            armour: 2,
            skills: []
        )
    }

    static var blackOrc_goblin: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 6,
            skills: [
                .elusive
            ]
        )
    }
}
