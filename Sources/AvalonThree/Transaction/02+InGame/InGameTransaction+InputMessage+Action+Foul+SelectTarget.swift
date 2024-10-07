//
//  InGameTransaction+InputMessage+Action+Foul+SelectTarget.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func foulActionSelectTarget(
        target targetPlayerID: PlayerID
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let validTargets = actionContext.history.lastResult(
                { entry -> Set<PlayerID>? in
                    guard case .foulValidTargets(let validTargets) = entry else { return nil }
                    return validTargets
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard var player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("No square")
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard validTargets.contains(targetPlayerID) else {
            throw GameError("Invalid target player")
        }

        guard let targetSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        let roll = randomizers.foulDie.rollFoulDie()

        events.append(
            .rolledForFoul(coachID: actionContext.coachID, result: roll)
        )

        guard let direction = playerSquare.direction(to: targetSquare) else {
            throw GameError("No foul direction")
        }

        events.append(
            .playerFouled(
                playerID: player.id,
                from: playerSquare,
                to: targetSquare,
                direction: direction,
                targetPlayerID: targetPlayerID
            )
        )

        // mutate player
        switch roll {
        case .spotted,
             .takeThat:
            player.state = .inReserves
            table.players.update(with: player)

            events.append(
                .playerSentOff(playerID: player.id, playerSquare: playerSquare)
            )

            if let ball = table.playerHasABall(player) {
                try ballComesLoose(id: ball.id, square: playerSquare)
                try bounceBall(id: ball.id)
            }

        case .slipped:
            player.canTakeActions = false
            table.players.update(with: player)
            events.append(.playerCannotTakeActions(playerID: player.id, playerSquare: playerSquare))

        case .gotThem:
            break
        }

        // mutate target player
        switch roll {
        case .spotted,
             .slipped:
            break
        case .takeThat,
             .gotThem:
            try playerIsInjured(playerID: targetPlayerID, reason: .fouled)
        }

        return try endBlockAction()
    }
}
