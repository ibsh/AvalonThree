//
//  InGameTransaction+InputMessage+Action+Mark+ResolveInterferenceBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func markActionUseInterferenceBonusPlay() throws -> AddressedPrompt? {
        return try markActionResolveInterferenceBonusPlay(use: true)
    }

    mutating func markActionDeclineInterferenceBonusPlay() throws -> AddressedPrompt? {
        return try markActionResolveInterferenceBonusPlay(use: false)
    }

    private mutating func markActionResolveInterferenceBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            var (maxMarkDistance, validSquares) = actionContext.history.lastResult(
                { entry -> (Int, ValidMoveSquares)? in
                    guard case .markValidSquares(
                        let maxMarkDistance,
                        let validSquares
                    ) = entry else {
                        return nil
                    }
                    return (maxMarkDistance, validSquares)
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("No player square")
        }

        let bonusPlay = BonusPlay.interference

        if use {
            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: actionContext.coachID)

            // refresh valid squares now that the player has the bonus active

            maxMarkDistance = TableConstants.interferenceBonusPlayMaxMarkDistance

            let targetSquares: Set<Square>? = try {
                guard let targetPlayerID = actionContext.history.lastResult(
                    { entry -> PlayerID? in
                        guard case .markHasRequiredTargetPlayer(let targetPlayerID) = entry else {
                            return nil
                        }
                        return targetPlayerID
                    }
                ) else {
                    return nil
                }
                guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
                    throw GameError("No target player")
                }
                guard let targetPlayerSquare = targetPlayer.square else {
                    throw GameError("No target square")
                }
                return targetPlayerSquare.adjacentSquares.toSet()
            }()

            validSquares = try validMoveSquares(
                playerID: player.id,
                playerSquare: playerSquare,
                moveReason: .mark(targetSquares: targetSquares),
                maxDistance: maxMarkDistance
            )

            history.append(
                .markValidSquares(
                    maxMarkDistance: maxMarkDistance,
                    validSquares: validSquares
                )
            )
        }

        return AddressedPrompt(
            coachID: actionContext.coachID,
            prompt: .markActionSelectSquares(
                player: PromptBoardPlayer(
                    id: actionContext.playerID,
                    square: playerSquare
                ),
                validSquares: validSquares
            )
        )
    }
}
