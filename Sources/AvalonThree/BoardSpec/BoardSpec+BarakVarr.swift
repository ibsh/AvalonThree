//
//  BoardSpec+BarakVarr.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension BoardSpec {
    static var barakVarrFoundry: BoardSpec {
        BoardSpec(
            obstructedSquares: [
                Square(x: 1, y: 6),
                Square(x: 2, y: 6),
                Square(x: 8, y: 6),
                Square(x: 9, y: 6),
                Square(x: 1, y: 7),
                Square(x: 2, y: 7),
                Square(x: 8, y: 7),
                Square(x: 9, y: 7),
                Square(x: 1, y: 8),
                Square(x: 2, y: 8),
                Square(x: 8, y: 8),
                Square(x: 9, y: 8),
            ]
                .compactMap { $0 }
                .toSet(),
            trapdoorSquares: [
                Square(x: 5, y: 7)
            ]
                .compactMap { $0 }
                .toSet()
        )
    }
}
