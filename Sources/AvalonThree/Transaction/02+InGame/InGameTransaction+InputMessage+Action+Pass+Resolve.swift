//
//  InGameTransaction+InputMessage+Action+Pass+Resolve.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func resolvePassAction() throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let target = actionContext.history.lastResult(
                { entry -> PassTarget? in
                    guard case .passTarget(let target) = entry else { return nil }
                    return target
                }
            ),
            let box = actionContext.history.lastResult(
                { entry -> (Int, Int, Int)? in
                    guard case .passRolled(
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

        guard var ball = table.playerHasABall(player) else {
            throw GameError("Player has no ball")
        }

        // take the ball from the passing player
        ball.state = .loose(square: playerSquare)
        table.balls.update(with: ball)

        let hailMary = table.getActiveBonuses(coachID: player.coachID).contains(
            where: { $0.bonusPlay == .hailMaryPass }
        )

        let immediateSuccess: Int = {
            return hailMary
            ? TableConstants.hailMaryPassBonusPlayPassSuccess
            : TableConstants.rollOfSix
        }()

        // Fumble?

        if
            (modifiedRoll <= TableConstants.rollOfOne || unmodifiedRoll <= TableConstants.rollOfOne)
                && unmodifiedRoll < immediateSuccess
        {

            history.append(.actionFinished)

            events.append(
                .playerFumbledBall(playerID: player.id, playerSquare: playerSquare, ballID: ball.id)
            )
            events.append(
                .ballCameLoose(ballID: ball.id, ballSquare: playerSquare)
            )

            try bounceBall(id: ball.id)

            return try endAction()
        }

        // Success?

        guard let targetPlayer = table.getPlayer(id: target.targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let angle = playerSquare.angle(to: target.targetSquare) else {
            throw GameError("No throw angle")
        }

        if targetPlayer.spec.pass != nil {
            if unmodifiedRoll >= immediateSuccess || (!hailMary && modifiedRoll >= effectivePassStat) {

                history.append(.passSuccessful)
                history.append(.actionFinished)

                ball.state = .held(playerID: target.targetPlayerID)
                table.balls.update(with: ball)

                events.append(
                    .playerPassedBall(
                        playerID: player.id,
                        from: playerSquare,
                        to: target.targetSquare,
                        angle: angle,
                        ballID: ball.id
                    )
                )
                events.append(
                    .playerCaughtPass(
                        playerID: target.targetPlayerID,
                        playerSquare: target.targetSquare,
                        ballID: ball.id
                    )
                )

                return try endAction()
            }
        }

        // Failure

        history.append(.actionFinished)

        events.append(
            .playerPassedBall(
                playerID: player.id,
                from: playerSquare,
                to: target.targetSquare,
                angle: angle,
                ballID: ball.id
            )
        )
        events.append(
            .playerFailedCatch(
                playerID: target.targetPlayerID,
                playerSquare: target.targetSquare,
                ballID: ball.id
            )
        )

        try ballComesLoose(id: ball.id, square: target.targetSquare)
        try bounceBall(id: ball.id)

        return try endAction()
    }
}
