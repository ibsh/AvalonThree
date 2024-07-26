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

        let bonusPlay = BonusPlay.legUp

        if table.getHand(
            coachID: turnContext.coachID
        ).contains(where: { $0.bonusPlay == bonusPlay }) {

            try useBonusPlay(bonusPlay: bonusPlay, coachID: turnContext.coachID)

            table.incrementScore(
                coachID: turnContext.coachID,
                increment: TableConstants.legUpBonusPlayScoreValue
            )

            events.append(
                .scoreUpdated(
                    coachID: turnContext.coachID,
                    increment: TableConstants.legUpBonusPlayScoreValue
                )
            )
        }
    }
}
