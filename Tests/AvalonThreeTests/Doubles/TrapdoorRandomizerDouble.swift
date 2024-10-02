//
//  TrapdoorRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func trapdoor(_ nextResults: Square...) -> TrapdoorRandomizing {
    TrapdoorRandomizerDouble(nextResults)
}

private final class TrapdoorRandomizerDouble: TrapdoorRandomizing {

    private var nextResults: [Square] = []

    init(_ nextResults: [Square]) {
        self.nextResults = nextResults
    }

    func selectRandomTrapdoor(from squares: Set<Square>) -> Square {
        nextResults.popFirst() ?? DefaultTrapdoorRandomizer().selectRandomTrapdoor(from: squares)
    }
}
