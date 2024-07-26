//
//  BoardSpec+Altdorf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension BoardSpec {
    static var altdorfOldTown: BoardSpec {
        BoardSpec(
            obstructedSquares: [
                Square(x: 4, y: 4),
                Square(x: 5, y: 4),
                Square(x: 6, y: 4),
                Square(x: 4, y: 5),
                Square(x: 5, y: 5),
                Square(x: 6, y: 5),
                Square(x: 4, y: 9),
                Square(x: 5, y: 9),
                Square(x: 6, y: 9),
                Square(x: 4, y: 10),
                Square(x: 5, y: 10),
                Square(x: 6, y: 10),
            ]
                .compactMap { $0 }
                .toSet(),
            trapdoorSquares: [
                Square(x: 1, y: 7),
                Square(x: 9, y: 7),
            ]
                .compactMap { $0 }
                .toSet()
        )
    }
}
