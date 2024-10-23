//
//  DeckRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func deck(_ nextResult: [ChallengeCard]?) -> DeckRandomizing {
    DeckRandomizerDouble(nextResult)
}

private final class DeckRandomizerDouble: DeckRandomizing {

    private var nextResult: [ChallengeCard]?

    init(_ nextResult: [ChallengeCard]?) {
        self.nextResult = nextResult
    }

    func deal(_ config: ChallengeDeckConfig) -> [ChallengeCard] {
        nextResult ?? DefaultDeckRandomizer().deal(config)
    }
}
