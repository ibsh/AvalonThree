//
//  InGameTransaction+InputMessage+Action+Block+TargetPlayerInjured.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionTargetPlayerInjured() throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            ),
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

        history.append(.blockTargetInjured)

        try playerIsInjured(playerID: targetPlayerID, reason: .blocked)

        if player.spec.skills.contains(.enforcer), results.dice.count > 1 {
            return try blockActionContinueWithEnforcer()
        }

        return try endBlockAction()
    }
}
