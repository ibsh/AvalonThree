//
//  PlayerSpec+Snotling.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension PlayerSpec {
    static var snotling_snotling: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 5,
            armour: nil,
            skills: [.insignificant]
        )
    }

    static var snotling_fungusFlinga: PlayerSpec {
        PlayerSpec(
            move: .fixed(5),
            block: 1,
            pass: 4,
            armour: nil,
            skills: [.bomber]
        )
    }

    static var snotling_funHoppa: PlayerSpec {
        PlayerSpec(
            move: .fixed(6),
            block: 1,
            pass: 5,
            armour: nil,
            skills: [.leap]
        )
    }

    static var snotling_stiltyRunna: PlayerSpec {
        PlayerSpec(
            move: .fixed(7),
            block: 1,
            pass: 5,
            armour: nil,
            skills: []
        )
    }

    static var snotling_pumpWagon: PlayerSpec {
        PlayerSpec(
            move: .random(.d6),
            block: 3,
            pass: nil,
            armour: 3,
            skills: [.warMachine]
        )
    }
}
