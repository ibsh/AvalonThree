//
//  D6RandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class D6RandomizerDouble: D6Randomizing {

    var nextResults: [Int] = []

    func roll() -> Int {
        nextResults.popFirst() ?? DefaultD6Randomizer().roll()
    }

    var range: ClosedRange<Int> {
        TableConstants.d6Range
    }

    var die: Die {
        .d6
    }
}
