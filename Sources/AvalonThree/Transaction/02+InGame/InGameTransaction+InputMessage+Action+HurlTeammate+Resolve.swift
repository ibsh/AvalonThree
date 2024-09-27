//
//  InGameTransaction+InputMessage+Action+HurlTeammate+Resolve.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func resolveHurlTeammateAction() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let teammateID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .hurlTeammateTeammate(let teammateID) = entry else { return nil }
                    return teammateID
                }
            ),
            let target = actionContext.history.lastResult(
                { entry -> HurlTeammateTarget? in
                    guard case .hurlTeammateTarget(let target) = entry else { return nil }
                    return target
                }
            ),
            let box = actionContext.history.lastResult(
                { entry -> (Int, Int, Int)? in
                    guard case .hurlTeammateRolled(
                        let effectivePassStat,
                        let unmodifiedRoll,
                        let modifiedRoll
                    ) = entry else { return nil }
                    return (effectivePassStat, unmodifiedRoll, modifiedRoll)
                }
            )
        else {
            throw GameError("No action in history")
        }

        let effectivePassStat = box.0
        let unmodifiedRoll = box.1
        let modifiedRoll = box.2

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        guard var teammate = table.getPlayer(id: teammateID) else {
            throw GameError("No teammate")
        }

        guard let angle = playerSquare.angle(to: target.targetSquare) else {
            throw GameError("No hurl teammate angle")
        }

        let teammatesBallID = table.playerHasABall(teammate)?.id

        // Fumble?

        if
            (modifiedRoll <= TableConstants.rollOfOne || unmodifiedRoll <= TableConstants.rollOfOne)
                && unmodifiedRoll < TableConstants.rollOfSix
        {

            events.append(
                .playerFumbledTeammate(
                    playerID: player.id,
                    in: playerSquare,
                    teammateID: teammateID,
                    ballID: teammatesBallID
                )
            )

            // finish the action
            history.append(.actionFinished)

            // move the player to the same square as the hurler, in order to bounce any ball they
            // were holding appropriately.
            teammate.state = .standing(square: playerSquare)
            table.players.update(with: teammate)

            try playerIsInjured(playerID: teammateID, reason: .fumbled)

            return try endAction()
        }

        // Success?

        if unmodifiedRoll >= TableConstants.rollOfSix || modifiedRoll >= effectivePassStat {

            // finish the action
            history.append(.hurlTeammateSuccessful)
            history.append(.actionFinished)

            if teammate.isProne != nil {
                teammate.state = .prone(square: target.targetSquare)
            } else {
                teammate.state = .standing(square: target.targetSquare)
            }
            table.players.update(with: teammate)

            events.append(
                .playerHurledTeammate(
                    playerID: player.id,
                    teammateID: teammate.id,
                    ballID: teammatesBallID,
                    from: playerSquare,
                    to: target.targetSquare,
                    angle: angle
                )
            )
            events.append(
                .hurledTeammateLanded(
                    playerID: teammateID,
                    ballID: teammatesBallID,
                    in: target.targetSquare
                )
            )

            while true {
                if let looseBall = table.looseBalls(in: target.targetSquare).first {
                    try bounceBall(id: looseBall.id)
                } else {
                    break
                }
            }

            return try endAction()
        }

        // Failure

        // finish the action
        history.append(.actionFinished)
        teammate.state = .prone(square: target.targetSquare)
        table.players.update(with: teammate)

        events.append(
            .playerHurledTeammate(
                playerID: player.id,
                teammateID: teammate.id,
                ballID: teammatesBallID,
                from: playerSquare,
                to: target.targetSquare,
                angle: angle
            )
        )
        events.append(
            .hurledTeammateCrashed(
                playerID: teammateID,
                ballID: teammatesBallID,
                in: target.targetSquare
            )
        )

        while true {
            if let looseBall = table.looseBalls(in: target.targetSquare).first {
                try bounceBall(id: looseBall.id)
            } else {
                break
            }
        }

        if let ball = table.playerHasABall(teammate) {
            try ballComesLoose(id: ball.id, square: target.targetSquare)
            try bounceBall(id: ball.id)
        }

        return try endAction()
    }
}
