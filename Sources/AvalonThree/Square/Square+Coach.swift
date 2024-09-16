//
//  File.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/16/24.
//

import Foundation

extension Square {

    /// The home coach is always pushing north, the away coach south.
    static func endZoneSquares(coachID: CoachID) -> [Square] {
        switch coachID {
        case .home:
            Square.Constants.xRange
                .compactMap { Square(x: $0, y: Square.Constants.yRange.last!) }
        case .away:
            Square.Constants.xRange
                .compactMap { Square(x: $0, y: Square.Constants.yRange.first!) }
        }
    }
}
