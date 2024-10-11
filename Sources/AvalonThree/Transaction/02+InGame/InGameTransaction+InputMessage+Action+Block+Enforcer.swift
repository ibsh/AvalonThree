//
//  InGameTransaction+InputMessage+Action+Block+Enforcer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionContinueWithEnforcer() throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard var player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        let (results, dieIndex) = try { () -> (BlockResults, Int) in
            if let (results, oldDieIndex) = actionContext.history.lastResult(
                { entry -> (BlockResults, Int)? in
                    guard case .selectedBlockResult(let results, let dieIndex) = entry else { return nil }
                    return (results, dieIndex)
                }
            ) {
                return (results, oldDieIndex + 1)
            }

            if let results = actionContext.history.lastResult(
                { entry -> BlockResults? in
                    guard case .blockResults(let results) = entry else { return nil }
                    return results
                }
            ) {
                return (results, 0)
            }

            throw GameError("No block results in history")
        }()

        guard dieIndex < results.dice.count else {
            return try endBlockAction()
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        if targetPlayer.isInReserves {
            // We've already injured the target; all that's left is to disable the player.
            var newDieIndex = dieIndex
            while newDieIndex < results.dice.count {
                events.append(
                    .selectedBlockDieResult(
                        coachID: actionContext.coachID,
                        dieIndex: newDieIndex,
                        from: results
                    )
                )
                if [.miss, .tackle].contains(results.dice[newDieIndex]) {
                    if player.canTakeActions {
                        player.canTakeActions = false
                        table.players.update(with: player)
                        events.append(
                            .playerCannotTakeActions(
                                playerID: player.id,
                                playerSquare: player.square
                            )
                        )
                    }
                }
                newDieIndex += 1
            }

            return try endBlockAction()
        }

        // update the action
        return try blockActionSelectResult(dieIndex: dieIndex)
    }
}
