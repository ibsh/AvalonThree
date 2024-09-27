//
//  ChallengeCard.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public struct ChallengeCard: Hashable, Codable, Sendable {
    public let challenge: Challenge
    public let bonusPlay: BonusPlay
}

extension ChallengeCard {

    static var standardShortDeck: [ChallengeCard] {
        [
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
    }

    static var standardEndgameDeck: [ChallengeCard] {
        [
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
    }
}
