//
//  PlayerSpec.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

struct PlayerSpec: Equatable {
    let move: Move
    let block: Int
    let pass: Int?
    let armour: Int?
    let skills: [Skill]
}
