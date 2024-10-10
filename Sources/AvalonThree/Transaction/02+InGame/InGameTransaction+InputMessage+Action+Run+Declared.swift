//
//  InGameTransaction+InputMessage+Action+Run+Declared.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declaredRunAction() throws -> AddressedPrompt? {

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

        return AddressedPrompt(
            coachID: actionContext.coachID,
            prompt: .runActionSelectSquares(
                player: PromptBoardPlayer(
                    id: actionContext.playerID,
                    square: playerSquare
                ),
                maxRunDistance: maxRunDistance,
                validSquares: validSquares
            )
        )
    }

    private mutating func checkForBlockingPlay() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard let actionContext = try turnContext.actionContexts().last else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.blockingPlay

        guard
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            ),
            !actionContext.history.contains(.runEligibleForBlockingPlayBonusPlay),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: bonusPlay)
            )
        else {
            return nil
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        history.append(.runEligibleForBlockingPlayBonusPlay)

        return AddressedPrompt(
            coachID: actionContext.coachID,
            prompt: .runActionEligibleForBlockingPlayBonusPlay(
                player: PromptBoardPlayer(
                    id: actionContext.playerID,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForDodge() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard let actionContext = try turnContext.actionContexts().last else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.dodge

        guard
            !actionContext.history.contains(.runEligibleForDodgeBonusPlay),
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: bonusPlay)
            )
        else {
            return nil
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        history.append(.runEligibleForDodgeBonusPlay)

        return AddressedPrompt(
            coachID: actionContext.coachID,
            prompt: .runActionEligibleForDodgeBonusPlay(
                player: PromptBoardPlayer(
                    id: actionContext.playerID,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForSprint() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard let actionContext = try turnContext.actionContexts().last else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.sprint

        guard
            !actionContext.history.contains(.runEligibleForSprintBonusPlay),
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: bonusPlay)
            )
        else {
            return nil
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        history.append(.runEligibleForSprintBonusPlay)

        return AddressedPrompt(
            coachID: actionContext.coachID,
            prompt: .runActionEligibleForSprintBonusPlay(
                player: PromptBoardPlayer(
                    id: actionContext.playerID,
                    square: playerSquare
                )
            )
        )
    }
}
