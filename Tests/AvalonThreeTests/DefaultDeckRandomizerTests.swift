//
//  DefaultDeckRandomizerTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Testing
@testable import AvalonThree

struct DefaultDeckRandomizerTests {

    @Test func testShortRandomizedDeckIsARandomizedVersionOfShortStandardDeck() async throws {
        let standardDeck = ChallengeCard.standardShortDeck
        let randomizedDeck = DefaultDeckRandomizer()
            .deal(
                ChallengeDeckConfig(
                    useEndgameCards: false,
                    randomizeBonusPlays: true
                )
            )

        #expect(randomizedDeck.count == standardDeck.count)

        #expect(randomizedDeck.sorted() != standardDeck.sorted())

        #expect(
            randomizedDeck.map { $0.challenge }.sorted()
            == standardDeck.map { $0.challenge }.sorted()
        )

        #expect(
            randomizedDeck.map { $0.bonusPlay }.sorted()
            == standardDeck.map { $0.bonusPlay }.sorted()
        )
    }

    @Test func testLongStandardDeckCount() async throws {
        #expect(
            DefaultDeckRandomizer()
                .deal(
                    ChallengeDeckConfig(
                        useEndgameCards: true,
                        randomizeBonusPlays: false
                    )
                )
                .count == 30
        )
    }

    @Test func testLongRandomizedDeckCount() async throws {
        #expect(
            DefaultDeckRandomizer()
                .deal(
                    ChallengeDeckConfig(
                        useEndgameCards: true,
                        randomizeBonusPlays: true
                    )
                )
                .count == 30
        )
    }

    @Test func testLongStandardDeckStartsWithShortStandardDeck() async throws {
        let longDeck = DefaultDeckRandomizer()
            .deal(
                ChallengeDeckConfig(
                    useEndgameCards: true,
                    randomizeBonusPlays: false
                )
            )
        let shortDeck = ChallengeCard.standardShortDeck
        let longDeckPrefix = Array(longDeck.prefix(shortDeck.count))

        #expect(longDeckPrefix.sorted() == shortDeck.sorted())
    }

    @Test func testLongRandomizedDeckStartsWithARandomizedShortStandardDeck() async throws {
        let longDeck = DefaultDeckRandomizer()
            .deal(
                ChallengeDeckConfig(
                    useEndgameCards: true,
                    randomizeBonusPlays: true
                )
            )
        let shortDeck = ChallengeCard.standardShortDeck
        let longDeckPrefix = Array(longDeck.dropLast(longDeck.count - shortDeck.count)).sorted()

        #expect(
            longDeckPrefix.map { $0.challenge }.sorted()
            == shortDeck.map { $0.challenge }.sorted()
        )

        #expect(
            longDeckPrefix.map { $0.bonusPlay }.sorted()
            == shortDeck.map { $0.bonusPlay }.sorted()
        )
    }

    @Test func testLongStandardDeckEndsWithCardsFromStandardEndgameDeck() async throws {
        let longDeck = DefaultDeckRandomizer()
            .deal(
                ChallengeDeckConfig(
                    useEndgameCards: true,
                    randomizeBonusPlays: false
                )
            )
        let shortDeck = ChallengeCard.standardShortDeck
        let longDeckSuffix = Array(longDeck.suffix(longDeck.count - shortDeck.count))

        #expect(longDeckSuffix.count == 6)

        let endgameDeck = ChallengeCard.standardEndgameDeck
        for card in longDeckSuffix {
            #expect(endgameDeck.contains(card))
        }
    }

    @Test func testLongRandomizedDeckEndsWithCardsRandomizedFromTheEndgameDeck() async throws {
        let longDeck = DefaultDeckRandomizer()
            .deal(
                ChallengeDeckConfig(
                    useEndgameCards: true,
                    randomizeBonusPlays: true
                )
            )
        let shortDeck = ChallengeCard.standardShortDeck
        let longDeckSuffix = Array(longDeck.suffix(longDeck.count - shortDeck.count))

        #expect(longDeckSuffix.count == 6)

        let endgameDeck = ChallengeCard.standardEndgameDeck
        let endgameChallenges = endgameDeck.map { $0.challenge }
        let endgameBonusPlays = endgameDeck.map { $0.bonusPlay }
        for card in longDeckSuffix {
            #expect(endgameChallenges.contains(card.challenge))
            #expect(endgameBonusPlays.contains(card.bonusPlay))
        }
    }
}
