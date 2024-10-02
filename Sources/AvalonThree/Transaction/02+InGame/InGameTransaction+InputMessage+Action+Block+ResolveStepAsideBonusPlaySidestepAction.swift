//
//  InGameTransaction+InputMessage+Action+Block+ResolveStepAsideBonusPlaySidestepAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .stepAside }

    mutating func blockActionUseStepAsideBonusPlaySidestepAction() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            )
        else {
            throw GameError("No action in history")
        }

        _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: targetPlayerID.coachID)

        history.append(.actionCancelled)
        history.append(.actionFinished)

        return try declareSidestepAction(
            playerID: targetPlayerID,
            isFree: true
        )
    }

    mutating func blockActionDeclineStepAsideBonusPlaySidestepAction() throws -> Prompt? {
        return try blockActionPrepareToRollDice()
    }
}
