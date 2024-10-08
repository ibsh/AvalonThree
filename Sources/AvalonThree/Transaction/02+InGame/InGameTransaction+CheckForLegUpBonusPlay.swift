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

        guard !turnContext.history.contains(
            .usedBonusPlay(coachID: coachID, bonusPlay: bonusPlay)
        ) else { return }

        if table.getHand(
            coachID: coachID
        ).contains(where: { $0.bonusPlay == bonusPlay }) {

            let card = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)

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

            try discardActiveBonusPlay(card: card, coachID: coachID)
        }
    }
}
