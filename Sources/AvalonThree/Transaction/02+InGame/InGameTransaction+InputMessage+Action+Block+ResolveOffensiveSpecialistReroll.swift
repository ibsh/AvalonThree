//
//  InGameTransaction+InputMessage+Action+Block+ResolveOffensiveSpecialistReroll.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseOffensiveSpecialistSkillReroll() throws -> Prompt? {
        guard let actionContext = try history.latestTurnContext().actionContexts().last else {
            throw GameError("No action in history")
        }

        events.append(
            .usedOffensiveSpecialistSkillReroll(playerID: actionContext.playerID)
        )

        return try blockActionRollDice()
    }

    mutating func blockActionDeclineOffensiveSpecialistSkillReroll(
        result: BlockDieResult
    ) throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        events.append(
            .declinedOffensiveSpecialistSkillReroll(playerID: actionContext.playerID)
        )

        // update the action
        return try blockActionSelectResult(result: result)
    }
}
