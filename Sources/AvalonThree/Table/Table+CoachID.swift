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

    mutating func addActiveBonus(
        coachID: CoachID,
        activeBonus: ChallengeCard
    ) {
        if coachID == coinFlipLoserCoachID {
            coinFlipLoserActiveBonuses.append(activeBonus)
        } else {
            coinFlipWinnerActiveBonuses.append(activeBonus)
        }
    }

    mutating func removeActiveBonus(
        coachID: CoachID,
        activeBonus: ChallengeCard
    ) throws -> ChallengeCard {
        if coachID == coinFlipLoserCoachID {
            guard let card = coinFlipLoserActiveBonuses.removeFirst(
                where: { $0 == activeBonus }
            ) else {
                throw GameError("No active bonus")
            }
            return card
        } else {
            guard let card = coinFlipWinnerActiveBonuses.removeFirst(
                where: { $0 == activeBonus }
            ) else {
                throw GameError("No active bonus")
            }
            return card
        }
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
