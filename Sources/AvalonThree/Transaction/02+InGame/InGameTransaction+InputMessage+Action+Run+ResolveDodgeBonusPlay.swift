//
//  InGameTransaction+InputMessage+Action+Run+ResolveDodgeBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func runActionUseDodgeBonusPlay() throws -> AddressedPrompt? {
        return try runActionResolveDodgeBonusPlay(use: true)
    }

    mutating func runActionDeclineDodgeBonusPlay() throws -> AddressedPrompt? {
        return try runActionResolveDodgeBonusPlay(use: false)
    }

    private mutating func runActionResolveDodgeBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let maxRunDistance = actionContext.history.lastResult(
                { entry -> Int? in
                    guard case .runValidSquares(let maxRunDistance, _) = entry else { return nil }
                    return maxRunDistance
                }
            )
        else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.dodge

        if use {

            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: actionContext.coachID)

            // refresh valid squares now that the player has the bonus active

            guard let player = table.getPlayer(id: actionContext.playerID) else {
                throw GameError("No player")
            }

            guard let playerSquare = player.square else {
                throw GameError("No player square")
            }

            let validSquares = try validMoveSquares(
                playerID: player.id,
                playerSquare: playerSquare,
                moveReason: .run,
                maxDistance: maxRunDistance
            )

            history.append(
                .runValidSquares(
                    maxRunDistance: maxRunDistance,
                    validSquares: validSquares
                )
            )
        }

        return try declaredRunAction()
    }
}
