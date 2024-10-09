//
//  InGameTransaction+InputMessage+Action+Pass+ResolveRawTalentBonusPlayReroll.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .rawTalent }

    mutating func passActionUseRawTalentBonusPlayReroll() throws -> AddressedPrompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        return try useRawTalentBonusPlay(
            coachID: actionContext.coachID,
            action: .passActionRollDie
        )
    }

    mutating func passActionDeclineRawTalentBonusPlayReroll() throws -> AddressedPrompt? {
        return try resolvePassAction()
    }
}
