//
//  InGameTransaction+UseBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func useBonusPlay(
        bonusPlay: BonusPlay,
        coachID: CoachID
    ) throws -> ChallengeCard {

        var hand = table.getHand(coachID: coachID)
        guard let card = hand.removeFirst(where: { $0.bonusPlay == bonusPlay }) else {
            throw GameError("No bonus play")
        }

        let turnContext = try history.latestTurnContext()

        guard !turnContext.history.contains(
            .usedBonusPlay(coachID: coachID, bonusPlay: bonusPlay)
        ) else {
            throw GameError("Already used an identical bonus play this turn")
        }

        table.setHand(coachID: coachID, hand: hand)
        table.addActiveBonus(coachID: coachID, activeBonus: card)

        history.append(.usedBonusPlay(coachID: coachID, bonusPlay: bonusPlay))

        events.append(
            .activatedBonusPlay(
                coachID: coachID,
                card: card,
                hand: hand.map { .open(card: $0) },
                active: table.getActiveBonuses(coachID: coachID)
            )
        )

        return card
    }
}
