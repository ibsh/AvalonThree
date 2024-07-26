//
//  PlayerSpec+Khorne.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var khorne_marauder: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 4,
            skills: []
        )
    }

    static var khorne_khorngor: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 4,
            armour: 4,
            skills: [.headbutt]
        )
    }

    static var khorne_bloodseeker: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 2,
            pass: 6,
            armour: 3,
            skills: [.enforcer]
        )
    }
}
