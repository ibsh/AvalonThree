//
//  InGameTransaction+InputMessage+Action+Block+ChooseResult.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionSelectResult(
        result: BlockDieResult
    ) throws -> Prompt? {

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
                { entry -> [BlockDieResult]? in
                    guard case .blockResults(let results) = entry else { return nil }
                    return results
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard results.contains(result) else {
            throw GameError("Result is not a valid choice")
        }

        guard var player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        guard var targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        events.append(
            .selectedBlockDieResult(coachID: player.coachID, result: result)
        )

        if !actionContext.history.contains(.blockAnimationEventsSent) {
            history.append(.blockAnimationEventsSent)
            if actionContext.history.contains(.blockIsBomb) {
                events.append(.playerThrewBomb(playerID: player.id, square: targetSquare))
            } else {
                events.append(.playerBlocked(playerID: player.id, square: targetSquare))
                for assistingPlayerID in actionContext.history.compactMap({ entry -> PlayerID? in
                    guard case .blockAssistingPlayer(let playerID) = entry else { return nil }
                    return playerID
                }) {
                    events.append(
                        .playerAssistedBlock(playerID: assistingPlayerID, square: targetSquare)
                    )
                }
            }
        }

        // disable player?

        switch result {
        case .miss,
             .tackle:
            if player.canTakeActions {
                player.canTakeActions = false
                table.players.update(with: player)
                events.append(.playerCannotTakeActions(playerID: player.id))
            }

        case .shove,
             .smash,
             .kerrunch:
            break
        }

        // miss?

        if result == .miss {
            if player.spec.skills.contains(.enforcer), results.count > 1 {
                return try blockActionContinueWithEnforcer()
            }

            history.append(.blockResult(result))

            return try endBlockAction()
        }

        // shove?

        if result == .shove {
            guard let direction = playerSquare.direction(to: targetSquare) else {
                throw GameError("Couldn't derive shove direction")
            }

            if let shovedToSquare = targetSquare.inDirection(direction),
                table.squareIsUnobstructed(shovedToSquare),
                table.squareIsEmptyOfPlayers(shovedToSquare)
            {

                try playerMovesIntoSquare(
                    playerID: targetPlayerID,
                    newSquare: shovedToSquare,
                    isFinalSquare: true,
                    reason: .shoved
                )

                if player.spec.skills.contains(.enforcer), results.count > 1 {
                    try playerMovesIntoSquare(
                        playerID: player.id,
                        newSquare: targetSquare,
                        isFinalSquare: true,
                        reason: .followUp
                    )
                    return try blockActionContinueWithEnforcer()
                }

                // update the action
                history.append(.blockResult(result))
                history.append(.blockFollowUpSquare(targetSquare))

                return Prompt(
                    coachID: actionContext.coachID,
                    payload: .blockActionEligibleForFollowUp(
                        playerID: actionContext.playerID,
                        square: targetSquare
                    )
                )
            }
        }

        // knocked down

        if targetPlayer.isProne == nil {

            history.append(.blockTargetKnockedDown)
            targetPlayer.state = .prone(square: targetSquare)
            table.players.update(with: targetPlayer)
            events.append(.playerFellDown(playerID: targetPlayerID, reason: .blocked))

            if let ball = table.playerHasABall(targetPlayer) {

                try ballComesLoose(id: ball.id, square: targetSquare)

                if targetPlayer.spec.skills.contains(.safeHands) {

                    let directions = targetSquare
                        .adjacentSquares
                        .filter { adjacentSquare in
                            table.squareIsUnobstructed(adjacentSquare)
                        }
                        .compactMap { adjacentSquare in
                            targetSquare.direction(to: adjacentSquare)
                        }
                        .toSet()

                    // update the action
                    history.append(.blockResult(result))
                    history.append(.blockSafeHandsDirections(directions))

                    return Prompt(
                        coachID: targetPlayerID.coachID,
                        payload: .blockActionSelectSafeHandsLooseBallDirection(
                            playerID: targetPlayerID,
                            directions: directions
                        )
                    )

                } else {

                    try bounceBall(id: ball.id)
                }
            }
        }

        // update the action
        history.append(.blockResult(result))
        return try blockActionRollForArmour()
    }
}
