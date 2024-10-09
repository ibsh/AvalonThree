//
//  InGameTransaction+InputMessage+ResolveDivingTackleBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func useDivingTackleBonusPlayBlockAction() throws -> AddressedPrompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last
        else {
            throw GameError("No action in history")
        }

        _ = try useBonusPlay(bonusPlay: .divingTackle, coachID: actionContext.coachID)

        return try declareBlockAction(
            playerID: actionContext.playerID,
            isFree: true
        )
    }

    mutating func declineDivingTackleBonusPlayBlockAction() throws -> AddressedPrompt? {
        return try endAction()
    }
}
