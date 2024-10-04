//
//  BallIDRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation
@testable import AvalonThree

func ballID(_ nextResults: Int...) -> BallIDRandomizing {
    BallIDRandomizerDouble(nextResults)
}

private final class BallIDRandomizerDouble: BallIDRandomizing {

    private var nextResults: [Int]

    init(_ nextResults: [Int]) {
        self.nextResults = nextResults
    }

    func generate() -> Int {
        nextResults.popFirst() ?? DefaultBallIDRandomizer().generate()
    }
}
