//
//  BoardSpec+Ghrond.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension BoardSpec {
    static var ghrondGridiron: BoardSpec {
        BoardSpec(
            obstructedSquares: [
                Square(x: 5, y: 2),
                Square(x: 6, y: 2),
                Square(x: 5, y: 3),
                Square(x: 6, y: 3),
                Square(x: 1, y: 6),
                Square(x: 2, y: 6),
                Square(x: 1, y: 7),
                Square(x: 2, y: 7),
                Square(x: 8, y: 7),
                Square(x: 9, y: 7),
                Square(x: 4, y: 11),
                Square(x: 5, y: 11),
                Square(x: 4, y: 12),
                Square(x: 5, y: 12),
            ]
                .compactMap { $0 }
                .toSet(),
            trapdoorSquares: [
                Square(x: 6, y: 6),
                Square(x: 4, y: 8),
            ]
                .compactMap { $0 }
                .toSet()
        )
    }
}
