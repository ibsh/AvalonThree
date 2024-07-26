//
//  DefaultDeckRandomizerTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Testing
@testable import AvalonThree

struct DefaultDeckRandomizerTests {

    @Test func testShortRandomisedDeckIsARandomisedVersionOfShortStandardDeck() async throws {
        let standardDeck = ChallengeCard.standardShortDeck
        let randomisedDeck = DefaultDeckRandomizer().deal(.shortRandomised)

        #expect(randomisedDeck.count == standardDeck.count)

        #expect(randomisedDeck.sorted() != standardDeck.sorted())

        #expect(
            randomisedDeck.map { $0.challenge }.sorted()
            == standardDeck.map { $0.challenge }.sorted()
        )

        #expect(
            randomisedDeck.map { $0.bonusPlay }.sorted()
            == standardDeck.map { $0.bonusPlay }.sorted()
        )
    }

    @Test func testLongStandardDeckCount() async throws {
        #expect(DefaultDeckRandomizer().deal(.longStandard).count == 30)
    }

    @Test func testLongRandomisedDeckCount() async throws {
        #expect(DefaultDeckRandomizer().deal(.longRandomised).count == 30)
    }

    @Test func testLongStandardDeckStartsWithShortStandardDeck() async throws {
        let longDeck = DefaultDeckRandomizer().deal(.longStandard)
        let shortDeck = ChallengeCard.standardShortDeck
        let longDeckPrefix = Array(longDeck.prefix(shortDeck.count))

        #expect(longDeckPrefix.sorted() == shortDeck.sorted())
    }

    @Test func testLongRandomisedDeckStartsWithARandomisedShortStandardDeck() async throws {
        let longDeck = DefaultDeckRandomizer().deal(.longRandomised)
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
        let longDeck = DefaultDeckRandomizer().deal(.longStandard)
        let shortDeck = ChallengeCard.standardShortDeck
        let longDeckSuffix = Array(longDeck.suffix(longDeck.count - shortDeck.count))

        #expect(longDeckSuffix.count == 6)

        let endgameDeck = ChallengeCard.standardEndgameDeck
        for card in longDeckSuffix {
            #expect(endgameDeck.contains(card))
        }
    }

    @Test func testLongRandomisedDeckEndsWithCardsRandomisedFromTheEndgameDeck() async throws {
        let longDeck = DefaultDeckRandomizer().deal(.longRandomised)
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
