//
//  Table+CoachID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/23/24.
//

import Foundation

extension Table {

    func players(
        coachID: CoachID
    ) -> Set<Player> {
        players.filter { $0.coachID == coachID }
    }

    func teamID(
        coachID: CoachID
    ) -> TeamID {
        coachID == coinFlipLoserCoachID ? coinFlipLoserTeamID : coinFlipWinnerTeamID
    }

    func getHand(
        coachID: CoachID
    ) -> [ChallengeCard] {
        coachID == coinFlipLoserCoachID ? coinFlipLoserHand : coinFlipWinnerHand
    }

    mutating func setHand(
        coachID: CoachID,
        hand: [ChallengeCard]
    ) {
        if coachID == coinFlipLoserCoachID {
            coinFlipLoserHand = hand
        } else {
            coinFlipWinnerHand = hand
        }
    }

    func getActiveBonuses(
        coachID: CoachID
    ) -> [ChallengeCard] {
        coachID == coinFlipLoserCoachID ? coinFlipLoserActiveBonuses : coinFlipWinnerActiveBonuses
    }

    mutating func setActiveBonuses(
        coachID: CoachID,
        activeBonuses: [ChallengeCard]
    ) {
        if coachID == coinFlipLoserCoachID {
            coinFlipLoserActiveBonuses = activeBonuses
        } else {
            coinFlipWinnerActiveBonuses = activeBonuses
        }
    }

    mutating func removeActiveBonus(
        coachID: CoachID,
        activeBonus: BonusPlay
    ) throws -> ChallengeCard {
        var bonuses = getActiveBonuses(coachID: coachID)
        guard let card = bonuses.removeFirst(where: { $0.bonusPlay == activeBonus }) else {
            throw GameError("No active bonus")
        }
        setActiveBonuses(
            coachID: coachID,
            activeBonuses: bonuses
        )
        return card
    }

    func getScore(
        coachID: CoachID
    ) -> Int {
        coachID == coinFlipLoserCoachID ? coinFlipLoserScore : coinFlipWinnerScore
    }

    mutating func incrementScore(
        coachID: CoachID,
        increment: Int
    ) {
        if coachID == coinFlipLoserCoachID {
            coinFlipLoserScore += increment
        } else {
            coinFlipWinnerScore += increment
        }
    }
}
