//
//  InGameTransaction+InputMessage+Action+HurlTeammate+ResolveRawTalentBonusPlayReroll.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .rawTalent }

    mutating func hurlTeammateActionUseRawTalentBonusPlayReroll() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        return try useRawTalentBonusPlay(
            coachID: actionContext.coachID,
            action: .hurlTeammateActionRollDie
        )
    }

    mutating func hurlTeammateActionDeclineRawTalentBonusPlayReroll() throws -> Prompt? {
        return try resolveHurlTeammateAction()
    }
}
