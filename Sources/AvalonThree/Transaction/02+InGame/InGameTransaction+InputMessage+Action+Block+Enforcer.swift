//
//  InGameTransaction+InputMessage+Action+Block+Enforcer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionContinueWithEnforcer() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            ),
            var results = actionContext.history.lastResult(
                { entry -> [BlockDieResult]? in
                    guard case .blockResults(let results) = entry else { return nil }
                    return results
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard var player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard results.count > 1 else {
            throw GameError("Not enough results to continue")
        }

        _ = results.popFirst()

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        if targetPlayer.isInReserves {
            // We've already injured the target; all that's left is to disable the player.
            while let result = results.popFirst() {
                events.append(
                    .selectedBlockDieResult(coachID: actionContext.coachID, result: result)
                )
                if [.miss, .tackle].contains(result) {
                    if player.canTakeActions {
                        player.canTakeActions = false
                        table.players.update(with: player)
                        events.append(.playerCannotTakeActions(playerID: player.id))
                    }
                }
            }

            return try endBlockAction()
        }

        // update the action
        history.append(.blockResults(results))
        return try blockActionSelectResult(result: results[0])
    }
}
