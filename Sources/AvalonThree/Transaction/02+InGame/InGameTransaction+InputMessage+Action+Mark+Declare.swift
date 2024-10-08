//
//  InGameTransaction+InputMessage+Action+Mark+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareMarkAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> Prompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .mark
        )

        var targetPlayerID: PlayerID?
        var targetSquares: Set<Square>?

        let turnContext = try history.latestTurnContext()

        if table.getActiveBonuses(coachID: playerID.coachID).contains(
            where: { $0.bonusPlay == .intervention }
        ) {
            guard
                let previousActionContext = try turnContext.actionContexts().last,
                previousActionContext.coachID == playerID.coachID.inverse,
                previousActionContext.actionID == .run
            else {
                throw GameError("No previous run action")
            }
            targetPlayerID = previousActionContext.playerID
        }

        // set the action
        history.append(
            .actionDeclaration(
                declaration: declaration,
                snapshot: ActionSnapshot(table: table)
            )
        )
        if isFree {
            history.append(.actionIsFree)
        }

        if let targetPlayerID {
            history.append(.markHasRequiredTargetPlayer(targetPlayerID))

            guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
                throw GameError("No target player")
            }
            guard let targetPlayerSquare = targetPlayer.square else {
                throw GameError("No target square")
            }
            targetSquares = targetPlayerSquare.adjacentSquares.toSet()
        }

        let basicValidSquares = try validSquares(
            player: player,
            targetSquares: targetSquares,
            maxMarkDistance: TableConstants.maxMarkDistance
        )

        let interferenceValidSquares = try validSquares(
            player: player,
            targetSquares: targetSquares,
            maxMarkDistance: TableConstants.interferenceBonusPlayMaxMarkDistance
        )

        if table.getActiveBonuses(coachID: playerID.coachID).contains(where: { $0.bonusPlay == .interference }) {

            history.append(
                .markValidSquares(
                    maxMarkDistance: TableConstants.interferenceBonusPlayMaxMarkDistance,
                    validSquares: interferenceValidSquares
                )
            )

            events.append(
                .declaredAction(
                    declaration: declaration,
                    isFree: isFree,
                    playerSquare: playerSquare
                )
            )

            return Prompt(
                coachID: playerID.coachID,
                payload: .markActionSelectSquares(
                    playerID: playerID,
                    playerSquare: playerSquare,
                    validSquares: interferenceValidSquares
                )
            )
        }

        history.append(
            .markValidSquares(
                maxMarkDistance: TableConstants.maxMarkDistance,
                validSquares: basicValidSquares
            )
        )
        events.append(
            .declaredAction(
                declaration: declaration,
                isFree: isFree,
                playerSquare: playerSquare
            )
        )

        let bonusPlay = BonusPlay.interference

        if table
            .getHand(coachID: playerID.coachID)
            .contains(where: { $0.bonusPlay == bonusPlay }),
           !turnContext.history.contains(
            .usedBonusPlay(coachID: playerID.coachID, bonusPlay: bonusPlay)
           ),
           !interferenceValidSquares.final.subtracting(basicValidSquares.final).isEmpty
        {
            return Prompt(
                coachID: playerID.coachID,
                payload: .markActionEligibleForInterferenceBonusPlay(
                    playerID: playerID,
                    playerSquare: playerSquare
                )
            )
        }

        return Prompt(
            coachID: playerID.coachID,
            payload: .markActionSelectSquares(
                playerID: playerID,
                playerSquare: playerSquare,
                validSquares: basicValidSquares
            )
        )
    }

    private func validSquares(
        player: Player,
        targetSquares: Set<Square>?,
        maxMarkDistance: Int
    ) throws -> ValidMoveSquares {

        guard let playerSquare = player.square else {
            throw GameError("No square")
        }

        return try validMoveSquares(
            playerID: player.id,
            playerSquare: playerSquare,
            moveReason: .mark(targetSquares: targetSquares),
            maxDistance: maxMarkDistance
        )
    }
}
