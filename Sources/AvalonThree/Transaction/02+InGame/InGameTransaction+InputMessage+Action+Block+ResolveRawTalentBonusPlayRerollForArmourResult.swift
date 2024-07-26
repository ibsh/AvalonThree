//
//  InGameTransaction+InputMessage+Action+Block+ResolveRawTalentBonusPlayRerollForArmourResult.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .rawTalent }

    mutating func blockActionUseRawTalentBonusPlayRerollForArmourResult() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            )
        else {
            throw GameError("No action in history")
        }

        try useBonusPlay(bonusPlay: bonusPlay, coachID: targetPlayerID.coachID)

        return try blockActionRollForArmour()
    }

    mutating func blockActionDeclineRawTalentBonusPlayRerollForArmourResult() throws -> Prompt? {
        return try blockActionTargetPlayerInjured()
    }
}
