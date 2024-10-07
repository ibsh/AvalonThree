//
//  InGameTransaction+InputMessage+Action+Block+SelectTarget.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionSelectTarget(
        target targetPlayerID: PlayerID
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let validTargets = actionContext.history.lastResult(
                { entry -> Set<PlayerID>? in
                    guard case .blockValidTargets(let validTargets) = entry else { return nil }
                    return validTargets
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard validTargets.contains(targetPlayerID) else {
            throw GameError("Invalid target player")
        }
        let targetSquareAndIsBomb = try {
            if player.spec.skills.contains(.bomber),
                table.playerIsMarked(player) == nil
            {
                guard let targetSquare = targetPlayer.isStanding else {
                    throw GameError("Target player is not standing")
                }
                guard
                    playerSquare.naiveDistance(to: targetSquare) <= TableConstants.maxBombDistance
                else {
                    throw GameError("Target player is too far away")
                }
                return (targetSquare, true)

            } else {
                guard let targetSquare = table.playerIsMarked(targetPlayer) else {
                    throw GameError("Target player is not marked")
                }
                guard targetSquare.isAdjacent(to: playerSquare) else {
                    throw GameError("Target player is not adjacent")
                }
                return (targetSquare, false)
            }
        }()

        let targetSquare = targetSquareAndIsBomb.0
        let isBomb = targetSquareAndIsBomb.1

        var blockDiceCount = player.spec.block

        history.append(.blockTarget(targetPlayerID))

        if isBomb {
            history.append(.blockIsBomb)
        }

        if !isBomb,
            !player.spec.skills.contains(.warMachine)
        {

            let assistingPlayers = table.playersInSquares(targetSquare.adjacentSquares)
                .filter { adjacentPlayer in
                    adjacentPlayer.coachID == player.coachID
                    && adjacentPlayer.index != player.index
                    && adjacentPlayer.isStanding != nil
                }
                .sorted(by: { $0.id.index < $1.id.index })

            assistingPlayers.forEach { assistingPlayer in
                history.append(.blockAssistingPlayer(assistingPlayer.id))
            }

            if
                !assistingPlayers.isEmpty
                    || table.getActiveBonuses(coachID: player.coachID).contains(
                        where: { $0.bonusPlay == .defensivePlay }
                    )
                    || table.getActiveBonuses(coachID: player.coachID).contains(
                        where: { $0.bonusPlay == .nufflesBlessing }
                    )
            {
                blockDiceCount += 1
                history.append(.blockAssisted)
            }
        }

        history.append(.blockDiceCount(blockDiceCount))

        return try blockActionPrepareToRollDice()
    }
}
