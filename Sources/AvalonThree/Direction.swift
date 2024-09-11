//
//  Direction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

public enum Direction: CaseIterable, Codable, Sendable {
    case north
    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest
}

extension Direction {

    var nextClockwise: Direction {
        switch self {
        case .north: .northEast
        case .northEast: .east
        case .east: .southEast
        case .southEast: .south
        case .south: .southWest
        case .southWest: .west
        case .west: .northWest
        case .northWest: .north
        }
    }
}
