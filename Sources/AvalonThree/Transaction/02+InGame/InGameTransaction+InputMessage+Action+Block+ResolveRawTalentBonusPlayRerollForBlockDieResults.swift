//
//  InGameTransaction+InputMessage+Action+Block+ResolveRawTalentBonusPlayRerollForBlockDieResults.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .rawTalent }

    mutating func blockActionUseRawTalentBonusPlayRerollForBlockDieResults() throws -> AddressedPrompt? {
        guard let actionContext = try history.latestTurnContext().actionContexts().last else {
            throw GameError("No action in history")
        }

        return try useRawTalentBonusPlay(
            coachID: actionContext.coachID,
            action: .blockActionRollDice
        )
    }

    mutating func blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
        result: BlockDieResult?
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

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        if player.spec.skills.contains(.enforcer) || results.dice.count == 1 {

            guard result == nil else {
                throw GameError("May not select result")
            }
            return try blockActionSelectResult(result: results.dice[0])

        } else {

            guard let result else {
                throw GameError("Must select result")
            }
            return try blockActionSelectResult(result: result)
        }
    }
}
