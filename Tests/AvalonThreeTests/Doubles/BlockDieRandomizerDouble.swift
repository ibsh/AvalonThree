//
//  BlockDieRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func block(_ nextResults: BlockDieResult...) -> BlockDieRandomizing {
    BlockDieRandomizerDouble(nextResults)
}

private final class BlockDieRandomizerDouble: BlockDieRandomizing {

    private var nextResults: [BlockDieResult]

    init(_ nextResults: [BlockDieResult]) {
        self.nextResults = nextResults
    }

    func rollBlockDie() -> BlockDieResult {
        nextResults.popFirst() ?? DefaultBlockDieRandomizer().rollBlockDie()
    }
}
