//
//  InGameTransaction+YourTimeToShineBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/24/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay {
        .yourTimeToShine
    }

    mutating func continueYourTimeToShineBonusPlay() throws -> Prompt? {

        let coachID = try history.latestTurnContext().coachID

        guard table.getActiveBonuses(coachID: coachID).contains(
            where: { $0.bonusPlay == bonusPlay }
        ) else {
            throw GameError("No active bonus")
        }

        return try continueWithReservesAction()
    }

    private mutating func continueWithReservesAction() throws -> Prompt? {

        let turnContext = try history.latestTurnContext()
        let coachID = turnContext.coachID

        let promptCount = turnContext.history.count(
            where: { entry in
                guard case .eligibleForYourTimeToShineBonusPlayReservesAction = entry else {
                    return false
                }
                return true
            }
        )

        guard promptCount < TableConstants.yourTimeToShineBonusPlayFreeReservesActionCount else {
            return try continueWithRunAction()
        }

        let validPlayerIDs = try validDeclarations(coachID: coachID)
            .compactMap { validDeclaration -> PlayerID? in
                guard validDeclaration.actionID == .reserves else { return nil }
                return validDeclaration.playerID
            }
            .toSet()

        if !validPlayerIDs.isEmpty {
            history.append(
                .eligibleForYourTimeToShineBonusPlayReservesAction(validPlayerIDs)
            )
            return Prompt(
                coachID: coachID,
                payload: .eligibleForYourTimeToShineBonusPlayReservesAction(
                    validPlayers: validPlayerIDs
                )
            )
        }

        return try continueWithRunAction()
    }

    private mutating func continueWithRunAction() throws -> Prompt? {

        let turnContext = try history.latestTurnContext()
        let coachID = turnContext.coachID

        let promptCount = turnContext.history.count(
            where: { entry in
                guard case .eligibleForYourTimeToShineBonusPlayRunAction = entry else {
                    return false
                }
                return true
            }
        )

        guard promptCount < TableConstants.yourTimeToShineBonusPlayFreeRunActionCount else {
            return try finishUp()
        }

        let eligiblePlayerIDs = try turnContext
            .actionContexts()
            .compactMap { actionContext -> PlayerID? in
                guard
                    actionContext.isFinished,
                    !actionContext.isCancelled,
                    actionContext.actionID == .reserves
                else { return nil }
                return actionContext.playerID
            }

        let validPlayerIDs = try validDeclarations(coachID: coachID)
            .compactMap { validDeclaration in
                guard validDeclaration.actionID == .run else { return nil }
                return validDeclaration.playerID
            }
            .filter { eligiblePlayerIDs.contains($0) }
            .toSet()

        if !validPlayerIDs.isEmpty {
            history.append(
                .eligibleForYourTimeToShineBonusPlayRunAction(validPlayerIDs)
            )
            return Prompt(
                coachID: coachID,
                payload: .eligibleForYourTimeToShineBonusPlayRunAction(
                    validPlayers: validPlayerIDs
                )
            )
        }

        return try finishUp()
    }

    private mutating func finishUp() throws -> Prompt? {

        let turnContext = try history.latestTurnContext()
        let coachID = turnContext.coachID

        let activeBonusCards = table.getActiveBonuses(coachID: coachID)
        var maintainCards = [ChallengeCard]()
        var discardCards = [ChallengeCard]()
        for activeBonusCard in activeBonusCards {
            if activeBonusCard.bonusPlay == bonusPlay {
                discardCards.append(activeBonusCard)
            } else {
                maintainCards.append(activeBonusCard)
            }
        }
        table.setActiveBonuses(coachID: coachID, activeBonuses: maintainCards)
        for discardCard in discardCards {
            table.discards.append(discardCard)
            events.append(
                .discardedActiveBonusPlay(
                    coachID: coachID,
                    card: discardCard
                )
            )
            events.append(
                .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
            )
        }

        return try endAction()
    }

    mutating func useYourTimeToShineBonusPlayReservesAction(
        playerID: PlayerID
    ) throws -> Prompt? {
        guard let playerIDs = try history.latestTurnContext().history.lastResult(
            { entry -> Set<PlayerID>? in
                guard case .eligibleForYourTimeToShineBonusPlayReservesAction(
                    let playerIDs
                ) = entry else {
                    return nil
                }
                return playerIDs
            }
        ) else {
            throw GameError("No player IDs")
        }
        guard playerIDs.contains(playerID) else {
            throw GameError("Invalid player ID")
        }
        return try declareReservesAction(playerID: playerID, isFree: true)
    }

    mutating func declineYourTimeToShineBonusPlayReservesAction() throws -> Prompt? {
        return try continueYourTimeToShineBonusPlay()
    }

    mutating func useYourTimeToShineBonusPlayRunAction(
        playerID: PlayerID
    ) throws -> Prompt? {
        guard let playerIDs = try history.latestTurnContext().history.lastResult(
            { entry -> Set<PlayerID>? in
                guard case .eligibleForYourTimeToShineBonusPlayRunAction(
                    let playerIDs
                ) = entry else {
                    return nil
                }
                return playerIDs
            }
        ) else {
            throw GameError("No player IDs")
        }
        guard playerIDs.contains(playerID) else {
            throw GameError("Invalid player ID")
        }
        return try declareRunAction(playerID: playerID, isFree: true)
    }

    mutating func declineYourTimeToShineBonusPlayRunAction() throws -> Prompt? {
        return try continueYourTimeToShineBonusPlay()
    }
}
