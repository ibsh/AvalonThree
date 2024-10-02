//
//  D6RandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func d6(_ nextResults: Int...) -> D6Randomizing {
    D6RandomizerDouble(nextResults)
}

private final class D6RandomizerDouble: D6Randomizing {

    private var nextResults: [Int]

    init(_ nextResults: [Int]) {
        self.nextResults = nextResults
    }

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
