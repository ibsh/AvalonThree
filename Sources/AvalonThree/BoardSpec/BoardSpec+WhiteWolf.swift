//
//  BoardSpec+WhiteWolf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension BoardSpec {
    static var whiteWolfHolm: BoardSpec {
        BoardSpec(
            obstructedSquares: [
                Square(x: 1, y: 3),
                Square(x: 2, y: 3),
                Square(x: 8, y: 3),
                Square(x: 9, y: 3),
                Square(x: 1, y: 4),
                Square(x: 2, y: 4),
                Square(x: 8, y: 4),
                Square(x: 9, y: 4),
                Square(x: 1, y: 10),
                Square(x: 2, y: 10),
                Square(x: 8, y: 10),
                Square(x: 9, y: 10),
                Square(x: 1, y: 11),
                Square(x: 2, y: 11),
                Square(x: 8, y: 11),
                Square(x: 9, y: 11),
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
