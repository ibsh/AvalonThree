//
//  PassMeasure.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

struct PassMeasure: Hashable, Codable, Sendable {
    let distance: PassDistance
    let touchingSquares: Set<Square>
}

public enum PassDistance: String, Codable, Sendable {
    case handoff
    case short
    case long
}
