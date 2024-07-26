//
//  PassMeasure.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

struct PassMeasure: Hashable, Codable {
    let distance: PassDistance
    let touchingSquares: Set<Square>
}

public enum PassDistance: Codable {
    case handoff
    case short
    case long
}
