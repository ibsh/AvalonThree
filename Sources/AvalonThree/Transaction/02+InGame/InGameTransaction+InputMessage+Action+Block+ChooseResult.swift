//
//  InGameTransaction+InputMessage+Action+Block+ChooseResult.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionSelectResult(
        dieIndex: Int
    ) throws -> AddressedPrompt? {

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

        guard results.dice.indices.contains(dieIndex) else {
            throw GameError("Result is not a valid choice")
        }

        let result = results.dice[dieIndex]

        guard var player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        guard var targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetPlayerSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        history.append(.selectedBlockResult(results, dieIndex))

        events.append(
            .selectedBlockDieResult(
                coachID: player.coachID,
                dieIndex: dieIndex,
                from: results
            )
        )

        if !actionContext.history.contains(.blockAnimationEventsSent) {
            history.append(.blockAnimationEventsSent)
            if actionContext.history.contains(.blockIsBomb) {
                guard let angle = playerSquare.angle(to: targetPlayerSquare) else {
                    throw GameError("No angle")
                }
                events.append(
                    .playerThrewBomb(
                        playerID: player.id,
                        from: playerSquare,
                        to: targetPlayerSquare,
                        angle: angle
                    )
                )
            } else {
                guard let blockDirection = playerSquare.direction(to: targetPlayerSquare) else {
                    throw GameError("No direction")
                }
                events.append(
                    .playerBlocked(
                        playerID: player.id,
                        from: playerSquare,
                        to: targetPlayerSquare,
                        direction: blockDirection,
                        targetPlayerID: targetPlayerID
                    )
                )
                for assistingPlayerID in actionContext.history.compactMap({ entry -> PlayerID? in
                    guard case .blockAssistingPlayer(let playerID) = entry else { return nil }
                    return playerID
                }) {
                    guard let square = table.getPlayer(id: assistingPlayerID)?.square else {
                        throw GameError("Assisting player is in reserves")
                    }
                    guard let assistDirection = square.direction(to: targetPlayerSquare) else {
                        throw GameError("No direction")
                    }
                    events.append(
                        .playerAssistedBlock(
                            assistingPlayerID: assistingPlayerID,
                            from: square,
                            to: targetPlayerSquare,
                            direction: assistDirection,
                            targetPlayerID: targetPlayerID,
                            blockingPlayerID: player.id
                        )
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
                events.append(
                    .playerCannotTakeActions(playerID: player.id, playerSquare: player.square)
                )
            }

        case .shove,
             .smash,
             .kerrunch:
            break
        }

        // miss?

        if result == .miss {
            if player.spec.skills.contains(.enforcer) {
                return try blockActionContinueWithEnforcer()
            }

            return try endBlockAction()
        }

        // shove?

        if result == .shove {
            guard let direction = playerSquare.direction(to: targetPlayerSquare) else {
                throw GameError("Couldn't derive shove direction")
            }

            if let shovedToSquare = targetPlayerSquare.inDirection(direction),
                table.squareIsUnobstructed(shovedToSquare),
                table.squareIsEmptyOfPlayers(shovedToSquare)
            {

                try playerMovesIntoSquare(
                    playerID: targetPlayerID,
                    newSquare: shovedToSquare,
                    isFinalSquare: true,
                    reason: .shoved
                )

                if player.spec.skills.contains(.enforcer) {
                    try playerMovesIntoSquare(
                        playerID: player.id,
                        newSquare: targetPlayerSquare,
                        isFinalSquare: true,
                        reason: .followUp
                    )
                    return try blockActionContinueWithEnforcer()
                }

                // update the action
                history.append(.blockFollowUpSquare(targetPlayerSquare))

                return AddressedPrompt(
                    coachID: actionContext.coachID,
                    prompt: .blockActionEligibleForFollowUp(
                        player: PromptBoardPlayer(
                            id: player.id,
                            square: playerSquare
                        ),
                        destination: targetPlayerSquare
                    )
                )
            }
        }

        // knocked down

        if targetPlayer.isProne == nil {

            history.append(.blockTargetKnockedDown)
            targetPlayer.state = .prone(square: targetPlayerSquare)
            table.players.update(with: targetPlayer)
            events.append(
                .playerFellDown(playerID: targetPlayerID, playerSquare: targetPlayerSquare, reason: .blocked)
            )

            if let ball = table.playerHasABall(targetPlayer) {

                try ballComesLoose(id: ball.id, square: targetPlayerSquare)

                if targetPlayer.spec.skills.contains(.safeHands) {

                    let directions: Set<PromptDirection> = try targetPlayerSquare
                        .adjacentSquares
                        .compactMap { adjacentSquare in
                            guard
                                adjacentSquare != targetPlayerSquare,
                                table.squareIsUnobstructed(adjacentSquare)
                            else {
                                return nil
                            }
                            guard
                                let direction = targetPlayerSquare.direction(to: adjacentSquare)
                            else { throw GameError("Square is not adjacent") }
                            return PromptDirection(
                                direction: direction,
                                destination: adjacentSquare
                            )
                        }
                        .toSet()

                    // update the action
                    history.append(.blockSafeHandsDirections(Set(directions.map { $0.direction })))

                    return AddressedPrompt(
                        coachID: targetPlayerID.coachID,
                        prompt: .blockActionSelectSafeHandsLooseBallDirection(
                            player: PromptBoardPlayer(
                                id: targetPlayerID,
                                square: targetPlayerSquare
                            ),
                            directions: directions
                        )
                    )

                } else {

                    try bounceBall(id: ball.id)
                }
            }
        }

        // update the action
        return try blockActionRollForArmour()
    }
}
