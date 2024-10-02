//
//  D8RandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func d8(_ nextResults: Int...) -> D8Randomizing {
    D8RandomizerDouble(nextResults)
}

private final class D8RandomizerDouble: D8Randomizing {

    private var nextResults: [Int] = []

    init(_ nextResults: [Int]) {
        self.nextResults = nextResults
    }

    func roll() -> Int {
        nextResults.popFirst() ?? DefaultD8Randomizer().roll()
    }

    var range: ClosedRange<Int> {
        TableConstants.d8Range
    }

    var die: Die {
        .d8
    }
}
