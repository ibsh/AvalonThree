//
//  InGameTransaction+InputMessage+Action+Pass+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declarePassAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> AddressedPrompt? {

        guard let playerSquare = table.getPlayer(id: playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        let basicValidTargets = try getValidPassTargets(
            playerID: playerID,
            hailMaryPass: false
        )

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .pass
        )

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

        events.append(
            .declaredAction(
                declaration: declaration,
                isFree: isFree,
                playerSquare: playerSquare
            )
        )

        if
            table.getActiveBonuses(coachID: playerID.coachID)
                .contains(where: { $0.bonusPlay == .hailMaryPass})
        {

            let hailMaryPassValidTargets = try getValidPassTargets(
                playerID: playerID,
                hailMaryPass: true
            )

            history.append(.passValidTargets(hailMaryPassValidTargets))

            return AddressedPrompt(
                coachID: playerID.coachID,
                prompt: .passActionSelectTarget(
                    playerID: playerID,
                    playerSquare: playerSquare,
                    validTargets: hailMaryPassValidTargets
                )
            )
        }

        history.append(.passValidTargets(basicValidTargets))

        let turnContext = try history.latestTurnContext()

        let bonusPlay = BonusPlay.hailMaryPass

        if table
            .getHand(coachID: playerID.coachID)
            .contains(where: { $0.bonusPlay == bonusPlay }),
           !turnContext.history.contains(
            .usedBonusPlay(coachID: playerID.coachID, bonusPlay: bonusPlay)
           )
        {
            return AddressedPrompt(
                coachID: playerID.coachID,
                prompt: .passActionEligibleForHailMaryPassBonusPlay(
                    playerID: playerID,
                    playerSquare: playerSquare
                )
            )
        }

        return AddressedPrompt(
            coachID: playerID.coachID,
            prompt: .passActionSelectTarget(
                playerID: playerID,
                playerSquare: playerSquare,
                validTargets: basicValidTargets
            )
        )
    }

    func getValidPassTargets(
        playerID: PlayerID,
        hailMaryPass: Bool
    ) throws -> Set<PassTarget> {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("No square")
        }

        let openOpponentSquares = table.players(coachID: player.coachID.inverse)
            .compactMap { player in
                table.playerIsOpen(player)
            }
            .toSet()

        return table
            .players(coachID: player.coachID)
            .reduce(
                Set<PassTarget>()
            ) { partialResult, targetPlayer in
                guard
                    targetPlayer.id != player.id,
                    let targetSquare = targetPlayer.isStanding,
                    table.playerHasABall(targetPlayer) == nil,
                    let measure = playerSquare.measurePass(
                        to: targetSquare,
                        hailMaryPass: hailMaryPass
                    )
                else {
                    return partialResult
                }

                let obstructingSquares = measure
                    .touchingSquares
                    .filter { square in
                        table.boardSpecID.spec.obstructedSquares.contains(square)
                        || openOpponentSquares.contains(square)
                    }

                var markedTargetSquares = Set<Square>()
                if measure.distance != .handoff {
                    markedTargetSquares = table.players(coachID: player.coachID.inverse)
                        .compactMap { player in
                            guard
                                let square = table.playerIsMarked(player),
                                square.isAdjacent(to: targetSquare)
                            else { return nil }
                            return square
                        }
                        .toSet()
                }

                return partialResult.union([
                    PassTarget(
                        targetPlayerID: targetPlayer.id,
                        targetSquare: targetSquare,
                        distance: measure.distance,
                        obstructingSquares: obstructingSquares,
                        markedTargetSquares: markedTargetSquares
                    )
                ])
            }
    }
}
