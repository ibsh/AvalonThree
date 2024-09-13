//
//  Square+Direction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

extension Square {

    func inDirection(_ direction: Direction) -> Square? {
        return Square(
            x: x + direction.dx,
            y: y + direction.dy
        )
    }

    func direction(to targetSquare: Square) -> Direction? {
        guard targetSquare.isAdjacent(to: self) else { return nil }
        if x == targetSquare.x {
            if y < targetSquare.y {
                return .south
            }
            if y > targetSquare.y {
                return .north
            }
            return nil
        }
        if x < targetSquare.x {
            if y < targetSquare.y {
                return .southEast
            }
            if y > targetSquare.y {
                return .northEast
            }
            return .east
        }
        if y < targetSquare.y {
            return .southWest
        }
        if y > targetSquare.y {
            return .northWest
        }
        return .west
    }

    public func visualDirection(to targetSquare: Square) -> Direction? {
        guard targetSquare != self else { return nil }
        if targetSquare.isAdjacent(to: self) { return direction(to: targetSquare) }
        let angle = atan2(Double(targetSquare.y - self.y), Double(targetSquare.x - self.x)) * 180 / .pi
        switch angle {
        case (-180)..<(-157.5): return .west
        case (-157.5)..<(-112.5): return .northWest
        case (-112.5)..<(-67.5): return .north
        case (-67.5)..<(-22.5): return .northEast
        case (-22.5)..<22.5: return .east
        case 22.5..<67.5: return .southEast
        case 67.5..<112.5: return .south
        case 112.5..<157.5: return .southWest
        default: return .west
        }
    }
}

extension Direction {

    var dx: Int {
        switch self {
        case .north: 0
        case .northEast: 1
        case .east: 1
        case .southEast: 1
        case .south: 0
        case .southWest: -1
        case .west: -1
        case .northWest: -1
        }
    }

    var dy: Int {
        switch self {
        case .north: -1
        case .northEast: -1
        case .east: 0
        case .southEast: 1
        case .south: 1
        case .southWest: 1
        case .west: 0
        case .northWest: -1
        }
    }
}
