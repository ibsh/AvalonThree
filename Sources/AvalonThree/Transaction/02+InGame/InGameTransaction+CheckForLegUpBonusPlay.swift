//
//  InGameTransaction+CheckForLegUpBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/22/24.
//

import Foundation

extension InGameTransaction {

    mutating func checkForLegUpBonusPlay() throws {

        let turnContext = try history.latestTurnContext()
        let coachID = turnContext.coachID

        let bonusPlay = BonusPlay.legUp

        if table.getHand(
            coachID: coachID
        ).contains(where: { $0.bonusPlay == bonusPlay }) {

            try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)

            table.incrementScore(
                coachID: coachID,
                increment: TableConstants.legUpBonusPlayScoreValue
            )

            events.append(
                .scoreUpdated(
                    coachID: coachID,
                    increment: TableConstants.legUpBonusPlayScoreValue,
                    total: table.getScore(coachID: turnContext.coachID)
                )
            )

            let card = try table.removeActiveBonus(coachID: coachID, activeBonus: bonusPlay)
            table.discards.append(card)
            events.append(
                .discardedActiveBonusPlay(coachID: coachID, card: card)
            )
            events.append(
                .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
            )
        }
    }
}
