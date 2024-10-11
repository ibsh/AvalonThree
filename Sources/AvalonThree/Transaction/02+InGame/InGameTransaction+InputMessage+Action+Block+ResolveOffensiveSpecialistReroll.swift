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
        dieIndex: Int?
    ) throws -> AddressedPrompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let results = actionContext.history.lastResult(
                { entry -> BlockResults? in
                    guard case .blockResults(let results) = entry else { return nil }
                    return results
                }
            )
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

        if results.dice.count == 1 {

            guard dieIndex == nil else {
                throw GameError("May not select result")
            }
            return try blockActionSelectResult(dieIndex: 0)

        } else {

            guard let dieIndex else {
                throw GameError("Must select result")
            }
            return try blockActionSelectResult(dieIndex: dieIndex)
        }
    }
}
