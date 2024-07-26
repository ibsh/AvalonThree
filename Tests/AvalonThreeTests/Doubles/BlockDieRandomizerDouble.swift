//
//  BlockDieRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class BlockDieRandomizerDouble: BlockDieRandomizing {

    var nextResults: [BlockDieResult] = []

    func rollBlockDie() -> BlockDieResult {
        nextResults.popFirst() ?? DefaultBlockDieRandomizer().rollBlockDie()
    }
}
