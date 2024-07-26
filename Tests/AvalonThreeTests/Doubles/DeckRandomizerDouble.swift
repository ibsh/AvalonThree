//
//  DeckRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class DeckRandomizerDouble: DeckRandomizing {

    var nextResult: [ChallengeCard]?

    func deal(_ id: ChallengeDeckID) -> [ChallengeCard] {
        nextResult ?? DefaultDeckRandomizer().deal(id)
    }
}
