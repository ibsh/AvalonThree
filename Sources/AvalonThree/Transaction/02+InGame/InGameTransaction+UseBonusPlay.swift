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
    ) throws {

        var hand = table.getHand(coachID: coachID)
        guard let card = hand.removeFirst(where: { $0.bonusPlay == bonusPlay }) else {
            throw GameError("No bonus play")
        }
        table.setHand(coachID: coachID, hand: hand)

        switch bonusPlay.persistence {
        case .instant:
            events.append(.revealedInstantBonusPlay(coachID: coachID, bonusPlay: bonusPlay))
        case .oneAction,
             .oneTurn,
             .custom,
             .game:
            events.append(.revealedPersistentBonusPlay(coachID: coachID, bonusPlay: bonusPlay))
            let bonuses = table.getActiveBonuses(coachID: coachID)
            table.setActiveBonuses(
                coachID: coachID,
                activeBonuses: bonuses + [card]
            )
        }
    }
}
