//
//  InGameTransaction+InputMessage+Action+Block+ResolveOffensiveSpecialistReroll.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseOffensiveSpecialistSkillReroll() throws -> AddressedPrompt? {
        guard let actionContext = try history.latestTurnContext().actionContexts().last else {
            throw GameError("No action in history")
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        events.append(
            .usedOffensiveSpecialistSkillReroll(
                playerID: actionContext.playerID,
                playerSquare: playerSquare
            )
        )

        return try blockActionRollDice()
    }

    mutating func blockActionDeclineOffensiveSpecialistSkillReroll(
        result: BlockDieResult
    ) throws -> AddressedPrompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        events.append(
            .declinedOffensiveSpecialistSkillReroll(
                playerID: actionContext.playerID,
                playerSquare: playerSquare
            )
        )

        // update the action
        return try blockActionSelectResult(result: result)
    }
}
