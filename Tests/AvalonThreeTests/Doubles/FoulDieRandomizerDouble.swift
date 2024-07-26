//
//  FoulDieRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class FoulDieRandomizerDouble: FoulDieRandomizing {

    var nextResults: [FoulDieResult] = []

    func rollFoulDie() -> FoulDieResult {
        nextResults.popFirst() ?? DefaultFoulDieRandomizer().rollFoulDie()
    }
}
