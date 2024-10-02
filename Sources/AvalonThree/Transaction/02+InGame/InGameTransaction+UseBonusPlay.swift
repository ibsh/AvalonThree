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

        table.setHand(coachID: coachID, hand: hand)
        table.addActiveBonus(coachID: coachID, activeBonus: card)

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
