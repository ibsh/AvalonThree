//
//  DeckRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

public protocol DeckRandomizing {
    func deal(_ config: ChallengeDeckConfig) -> [ChallengeCard]
}

public final class DefaultDeckRandomizer {

    public init() { }

    private func combine(
        challenges: [Challenge],
        bonusPlays: [BonusPlay]
    ) -> [ChallengeCard] {
        zip(challenges, bonusPlays)
            .map {
                ChallengeCard(
                    challenge: $0,
                    bonusPlay: $1
                )
            }
    }
}

extension DefaultDeckRandomizer: DeckRandomizing {

    public func deal(_ config: ChallengeDeckConfig) -> [ChallengeCard] {
        switch (config.useEndgameCards, config.randomizeBonusPlays) {
        case (false, false):
            ChallengeCard.standardShortDeck.shuffled()
        case (false, true):
            combine(
                challenges: ChallengeCard.standardShortDeck.shuffled().map { $0.challenge },
                bonusPlays: ChallengeCard.standardShortDeck.shuffled().map { $0.bonusPlay }
            )
        case (true, false):
            ChallengeCard.standardShortDeck.shuffled()
            + Array(
                ChallengeCard.standardEndgameDeck.shuffled().prefix(6)
            )
        case (true, true):
            combine(
                challenges: ChallengeCard.standardShortDeck.shuffled().map { $0.challenge },
                bonusPlays: ChallengeCard.standardShortDeck.shuffled().map { $0.bonusPlay }
            )
            + Array(
                combine(
                    challenges: ChallengeCard.standardEndgameDeck.shuffled().map {
                        $0.challenge
                    },
                    bonusPlays: ChallengeCard.standardEndgameDeck.shuffled().map {
                        $0.bonusPlay
                    }
                )
            )
            .prefix(6)
        }
    }
}
