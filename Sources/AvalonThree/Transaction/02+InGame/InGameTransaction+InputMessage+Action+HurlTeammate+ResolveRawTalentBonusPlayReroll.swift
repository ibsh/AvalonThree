//
//  InGameTransaction+InputMessage+Action+HurlTeammate+ResolveRawTalentBonusPlayReroll.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func hurlTeammateActionUseRawTalentBonusPlayReroll() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        try useBonusPlay(bonusPlay: .rawTalent, coachID: actionContext.coachID)
        return try hurlTeammateActionRollDie()
    }

    mutating func hurlTeammateActionDeclineRawTalentBonusPlayReroll() throws -> Prompt? {
        return try resolveHurlTeammateAction()
    }
}
