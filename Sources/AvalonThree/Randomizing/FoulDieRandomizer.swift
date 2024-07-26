//
//  FoulDieRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

protocol FoulDieRandomizing {
    func rollFoulDie() -> FoulDieResult
}

struct DefaultFoulDieRandomizer: FoulDieRandomizing {

    private static let FoulDieFaces: Set<FoulDieResult> =
        [
            .spotted,
            .takeThat,
            .slipped,
            .slipped,
            .gotThem,
            .gotThem,
        ]

    func rollFoulDie() -> FoulDieResult {
        guard let result = DefaultFoulDieRandomizer.FoulDieFaces.randomElement() else {
            fatalError("No sides on my foul die")
        }
        return result
    }
}
