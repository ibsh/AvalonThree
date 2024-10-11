//
//  InGameTransaction+DiscardActiveBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 10/1/24.
//

import Foundation

extension InGameTransaction {

    mutating func discardActiveBonusPlay(
        card: ChallengeCard,
        coachID: CoachID
    ) throws {
        let removedCard = try table.removeActiveBonus(
            coachID: coachID,
            activeBonus: card
        )
        table.discards.append(removedCard)
        events.append(
            .discardedActiveBonusPlay(
                coachID: coachID,
                card: removedCard,
                hand: table.getHand(coachID: coachID).map { .open(card: $0) },
                active: table.getActiveBonuses(coachID: coachID)
            )
        )
        events.append(
            .updatedDiscards(
                top: table.discards.last?.bonusPlay,
                count: table.discards.count
            )
        )
    }
}
