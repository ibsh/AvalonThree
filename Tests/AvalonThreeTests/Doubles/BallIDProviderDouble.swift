//
//  BallIDProviderDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation
@testable import AvalonThree

func ballID(_ nextResults: Int...) -> BallIDProviding {
    BallIDProviderDouble(nextResults)
}

private final class BallIDProviderDouble: BallIDProviding {

    private var nextResults: [Int]
    private var nextValue = 1

    init(_ nextResults: [Int]) {
        self.nextResults = nextResults
    }

    func generate() -> Int {
        if let result = nextResults.popFirst() { return result }
        let result = nextValue
        nextValue += 1
        return result
    }
}
