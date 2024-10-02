//
//  FoulDieRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

public protocol FoulDieRandomizing {
    func rollFoulDie() -> FoulDieResult
}

public final class DefaultFoulDieRandomizer {
    private static let FoulDieFaces: Set<FoulDieResult> =
        [
            .spotted,
            .takeThat,
            .slipped,
            .slipped,
            .gotThem,
            .gotThem,
        ]

    public init() { }
}

extension DefaultFoulDieRandomizer: FoulDieRandomizing {

    public func rollFoulDie() -> FoulDieResult {
        guard let result = DefaultFoulDieRandomizer.FoulDieFaces.randomElement() else {
            fatalError("No sides on my foul die")
        }
        return result
    }
}
