//
//  InGameTransaction+InputMessage+Action+Pass+ResolveRawTalentBonusPlayReroll.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionUseRawTalentBonusPlayReroll() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        try useBonusPlay(bonusPlay: .rawTalent, coachID: actionContext.coachID)
        return try passActionRollDie()
    }

    mutating func passActionDeclineRawTalentBonusPlayReroll() throws -> Prompt? {
        return try resolvePassAction()
    }
}
