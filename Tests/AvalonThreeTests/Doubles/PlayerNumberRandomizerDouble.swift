//
//  PlayerNumberRandomizerDouble.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/26/24.
//

import Foundation
@testable import AvalonThree

func playerNumber(_ nextResults: Int...) -> PlayerNumberRandomizing {
    PlayerNumberRandomizerDouble(nextResults)
}

private final class PlayerNumberRandomizerDouble: PlayerNumberRandomizing {

    var nextResults: [Int]

    init(_ nextResults: [Int]) {
        self.nextResults = nextResults
    }

    func generate() -> Int {
        nextResults.popFirst() ?? DefaultPlayerNumberRandomizer().generate()
    }
}
