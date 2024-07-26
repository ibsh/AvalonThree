//
//  PlayerSpec+Chaos.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var chaos_beastman: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 4,
            skills: [.headbutt]
        )
    }

    static var chaos_chosenBlocker: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 2,
            pass: 5,
            armour: 2,
            skills: []
        )
    }
}
