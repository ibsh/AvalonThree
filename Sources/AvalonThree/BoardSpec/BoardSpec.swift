//
//  BoardSpec.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

struct BoardSpec: Codable {
    let obstructedSquares: Set<Square>
    let trapdoorSquares: Set<Square>
}
