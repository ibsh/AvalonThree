//
//  DeckRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

protocol DeckRandomizing {
    func deal(_ id: ChallengeDeckID) -> [ChallengeCard]
}

struct DefaultDeckRandomizer: DeckRandomizing {
    func deal(_ id: ChallengeDeckID) -> [ChallengeCard] {
        switch id {
        case .shortStandard:
            ChallengeCard.standardShortDeck.shuffled()
        case .shortRandomised:
            combine(
                challenges: ChallengeCard.standardShortDeck.shuffled().map { $0.challenge },
                bonusPlays: ChallengeCard.standardShortDeck.shuffled().map { $0.bonusPlay }
            )
        case .longStandard:
            ChallengeCard.standardShortDeck.shuffled()
            + Array(
                ChallengeCard.standardEndgameDeck.shuffled().prefix(6)
            )
        case .longRandomised:
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
