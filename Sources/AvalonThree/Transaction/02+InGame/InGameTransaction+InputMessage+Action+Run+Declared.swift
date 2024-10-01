//
//  InGameTransaction+InputMessage+Action+Run+Declared.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declaredRunAction() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let (maxRunDistance, validSquares) = actionContext.history.lastResult(
                { entry -> (Int, ValidMoveSquares)? in
                    guard
                        case .runValidSquares(
                            let maxRunDistance,
                            let validSquares
                        ) = entry
                    else { return nil }
                    return (maxRunDistance, validSquares)
                }
            )
        else {
            throw GameError("No action in history")
        }

        if let prompt = try checkForBlockingPlay() {
            return prompt
        }

        if let prompt = try checkForDodge() {
            return prompt
        }

        if let prompt = try checkForSprint() {
            return prompt
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        return Prompt(
            coachID: actionContext.coachID,
            payload: .runActionSpecifySquares(
                playerID: actionContext.playerID,
                in: playerSquare,
                maxRunDistance: maxRunDistance,
                validSquares: validSquares
            )
        )
    }

    private mutating func checkForBlockingPlay() throws -> Prompt? {

        guard let actionContext = try history.latestTurnContext().actionContexts().last else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.blockingPlay

        guard
            !actionContext.history.contains(.runEligibleForBlockingPlayBonusPlay),
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            )
        else {
            return nil
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        history.append(.runEligibleForBlockingPlayBonusPlay)

        return Prompt(
            coachID: actionContext.coachID,
            payload: .runActionEligibleForBlockingPlayBonusPlay(
                playerID: actionContext.playerID,
                in: playerSquare
            )
        )
    }

    private mutating func checkForDodge() throws -> Prompt? {

        guard let actionContext = try history.latestTurnContext().actionContexts().last else {
            throw GameError("No action in history")
        }

        guard
            !actionContext.history.contains(.runEligibleForDodgeBonusPlay),
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .dodge }
            )
        else {
            return nil
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        history.append(.runEligibleForDodgeBonusPlay)

        return Prompt(
            coachID: actionContext.coachID,
            payload: .runActionEligibleForDodgeBonusPlay(
                playerID: actionContext.playerID,
                in: playerSquare
            )
        )
    }

    private mutating func checkForSprint() throws -> Prompt? {

        guard let actionContext = try history.latestTurnContext().actionContexts().last else {
            throw GameError("No action in history")
        }

        guard
            !actionContext.history.contains(.runEligibleForSprintBonusPlay),
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .sprint }
            )
        else {
            return nil
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        history.append(.runEligibleForSprintBonusPlay)

        return Prompt(
            coachID: actionContext.coachID,
            payload: .runActionEligibleForSprintBonusPlay(
                playerID: actionContext.playerID,
                in: playerSquare
            )
        )
    }
}
