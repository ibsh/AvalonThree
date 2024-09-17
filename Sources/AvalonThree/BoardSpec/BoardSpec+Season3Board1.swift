//
//  BoardSpec+Ogham.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension BoardSpec {
    static var season3Board1: BoardSpec {
        BoardSpec(
            obstructedSquares: [
                Square(x: 3, y: 2),
                Square(x: 7, y: 2),
                Square(x: 2, y: 5),
                Square(x: 8, y: 5),
                Square(x: 2, y: 9),
                Square(x: 8, y: 9),
                Square(x: 3, y: 12),
                Square(x: 7, y: 12),
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
