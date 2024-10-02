//
//  InGameTransaction+InputMessage+ResolveShoulderChargeBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func useShoulderChargeBonusPlayBlockAction() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last
        else {
            throw GameError("No action in history")
        }

        _ = try useBonusPlay(bonusPlay: .shoulderCharge, coachID: actionContext.coachID)

        return try declareBlockAction(
            playerID: actionContext.playerID,
            isFree: true
        )
    }

    mutating func declineShoulderChargeBonusPlayBlockAction() throws -> Prompt? {
        return try endAction()
    }
}
