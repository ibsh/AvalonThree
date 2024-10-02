//
//  DirectionRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func direction(_ nextResults: Direction...) -> DirectionRandomizing {
    DirectionRandomizerDouble(nextResults)
}

private final class DirectionRandomizerDouble: DirectionRandomizing {

    var nextResults: [Direction]

    init(_ nextResults: [Direction]) {
        self.nextResults = nextResults
    }

    func rollForDirection() -> Direction {
        nextResults.popFirst() ?? DefaultDirectionRandomizer().rollForDirection()
    }
}
