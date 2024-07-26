//
//  ChallengeDeckIDTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Testing
@testable import AvalonThree

struct ChallengeDeckIDTests {

    @Test func testMyChallengeComparableExtensionBySorting() async throws {
        #expect(
            ChallengeCard.standardShortDeck.map { $0.challenge }.sorted() == [
                .breakSomeBones,
                .breakSomeBones,
                .freeUpTheBall,
                .freeUpTheBall,
                .gangUp,
                .gangUp,
                .getMoving,
                .getMoving,
                .getTheBall,
                .getTheBall,
                .getTogether,
                .makeARiskyPass,
                .moveTheBall,
                .moveTheBall,
                .showboatForTheCrowd,
                .showboatForTheCrowd,
                .showNoFear,
                .showUsACompletion,
                .showUsACompletion,
                .spreadOut,
                .takeThemDown,
                .takeThemDown,
                .tieThemUp,
                .tieThemUp,
            ]
        )

        #expect(
            ChallengeCard.standardEndgameDeck.map { $0.challenge }.sorted() == [
                .breakTheirLines,
                .breakTheirLines,
                .causeSomeCarnage,
                .causeSomeCarnage,
                .goDeep,
                .goDeep,
                .lastChance,
                .pileOn,
                .pileOn,
                .playAsATeam,
                .playAsATeam,
                .showOffALittle,
                .showOffALittle,
                .showSomeGrit,
                .showThemHowItsDone,
                .showThemHowItsDone,
            ]
        )
    }

    @Test func testMyBonusPlayComparableExtensionBySorting() async throws {
        #expect(
            ChallengeCard.standardShortDeck.map { $0.bonusPlay }.sorted() == [
                .accuratePass,
                .blitz,
                .blockingPlay,
                .defensivePlay,
                .distraction,
                .divingTackle,
                .dodge,
                .inspiration,
                .inspiration,
                .inspiration,
                .interference,
                .intervention,
                .jumpUp,
                .multiBall,
                .rawTalent,
                .rawTalent,
                .rawTalent,
                .reserves,
                .reserves,
                .shadow,
                .sprint,
                .stepAside,
                .passingPlay,
                .toughEnough,
            ]
        )

        #expect(
            ChallengeCard.standardEndgameDeck.map { $0.bonusPlay }.sorted() == [
                .absoluteCarnage,
                .absolutelyNails,
                .bladedKnuckleDusters,
                .bodyCheck,
                .bribedRef,
                .comboPlay,
                .getInThere,
                .hailMaryPass,
                .legUp,
                .nervesOfSteel,
                .nufflesBlessing,
                .pro,
                .readyToGo,
                .shoulderCharge,
                .theKidsGotMoxy,
                .yourTimeToShine,
            ]
        )
    }

    @Test func testMyChallengeCardComparableExtensionBySorting() async throws {
        #expect(
            ChallengeCard.standardShortDeck.sorted() == [
                ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                ChallengeCard(challenge: .breakSomeBones, bonusPlay: .stepAside),
                ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .blitz),
                ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .intervention),
                ChallengeCard(challenge: .gangUp, bonusPlay: .inspiration),
                ChallengeCard(challenge: .gangUp, bonusPlay: .toughEnough),
                ChallengeCard(challenge: .getMoving, bonusPlay: .interference),
                ChallengeCard(challenge: .getMoving, bonusPlay: .sprint),
                ChallengeCard(challenge: .getTheBall, bonusPlay: .distraction),
                ChallengeCard(challenge: .getTheBall, bonusPlay: .shadow),
                ChallengeCard(challenge: .getTogether, bonusPlay: .reserves),
                ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .accuratePass),
                ChallengeCard(challenge: .moveTheBall, bonusPlay: .dodge),
                ChallengeCard(challenge: .moveTheBall, bonusPlay: .rawTalent),
                ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .multiBall),
                ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .rawTalent),
                ChallengeCard(challenge: .showNoFear, bonusPlay: .jumpUp),
                ChallengeCard(challenge: .showUsACompletion, bonusPlay: .inspiration),
                ChallengeCard(challenge: .showUsACompletion, bonusPlay: .passingPlay),
                ChallengeCard(challenge: .spreadOut, bonusPlay: .reserves),
                ChallengeCard(challenge: .takeThemDown, bonusPlay: .divingTackle),
                ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration),
                ChallengeCard(challenge: .tieThemUp, bonusPlay: .defensivePlay),
                ChallengeCard(challenge: .tieThemUp, bonusPlay: .rawTalent),
            ]
        )

        #expect(
            ChallengeCard.standardEndgameDeck.sorted() == [
                ChallengeCard(challenge: .breakTheirLines, bonusPlay: .bladedKnuckleDusters),
                ChallengeCard(challenge: .breakTheirLines, bonusPlay: .bodyCheck),
                ChallengeCard(challenge: .causeSomeCarnage, bonusPlay: .absoluteCarnage),
                ChallengeCard(challenge: .causeSomeCarnage, bonusPlay: .bribedRef),
                ChallengeCard(challenge: .goDeep, bonusPlay: .nervesOfSteel),
                ChallengeCard(challenge: .goDeep, bonusPlay: .shoulderCharge),
                ChallengeCard(challenge: .lastChance, bonusPlay: .readyToGo),
                ChallengeCard(challenge: .pileOn, bonusPlay: .absolutelyNails),
                ChallengeCard(challenge: .pileOn, bonusPlay: .nufflesBlessing),
                ChallengeCard(challenge: .playAsATeam, bonusPlay: .getInThere),
                ChallengeCard(challenge: .playAsATeam, bonusPlay: .legUp),
                ChallengeCard(challenge: .showOffALittle, bonusPlay: .comboPlay),
                ChallengeCard(challenge: .showOffALittle, bonusPlay: .hailMaryPass),
                ChallengeCard(challenge: .showSomeGrit, bonusPlay: .yourTimeToShine),
                ChallengeCard(challenge: .showThemHowItsDone, bonusPlay: .pro),
                ChallengeCard(challenge: .showThemHowItsDone, bonusPlay: .theKidsGotMoxy),
            ]
        )
    }

    @Test func testStandardShortDeckCount() async throws {
        #expect(ChallengeCard.standardShortDeck.count == 24)
    }

    @Test func testStandardEndgameDeckCount() async throws {
        #expect(ChallengeCard.standardEndgameDeck.count == 16)
    }
}
