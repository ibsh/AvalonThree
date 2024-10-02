//
//  FoulDieRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func foul(_ nextResults: FoulDieResult...) -> FoulDieRandomizing {
    FoulDieRandomizerDouble(nextResults)
}

private final class FoulDieRandomizerDouble: FoulDieRandomizing {

    private var nextResults: [FoulDieResult]

    init(_ nextResults: [FoulDieResult]) {
        self.nextResults = nextResults
    }

    func rollFoulDie() -> FoulDieResult {
        nextResults.popFirst() ?? DefaultFoulDieRandomizer().rollFoulDie()
    }
}
