//
//  InGameTransaction+ReadyToGoBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/24/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay {
        .readyToGo
    }

    mutating func continueReadyToGoBonusPlay() throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        let coachID = turnContext.coachID

        guard table.getActiveBonuses(coachID: coachID).contains(
            where: { $0.bonusPlay == bonusPlay }
        ) else {
            throw GameError("No active bonus")
        }

        let players = table
            .players(coachID: coachID)
            .filter { player in
                !turnContext.history.contains(.eligibleForReadyToGoBonusPlayFreeAction(player.id))
            }
            .sorted(by: { $0.index < $1.index })

        let validDeclarations = try validDeclarations(coachID: coachID)

        for player in players where table.playerIsOpen(player) != nil {
            history.append(.eligibleForReadyToGoBonusPlayFreeAction(player.id))
            if validDeclarations.contains(
                where: { validDeclaration in
                    validDeclaration.playerID == player.id && validDeclaration.actionID == .run
                }
            ) {
                guard let playerSquare = player.square else {
                    throw GameError("Player is in reserves")
                }
                return Prompt(
                    coachID: coachID,
                    payload: .eligibleForReadyToGoBonusPlayRunAction(
                        playerID: player.id,
                        in: playerSquare
                    )
                )
            }
        }

        for player in players where table.playerIsMarked(player) != nil {
            history.append(.eligibleForReadyToGoBonusPlayFreeAction(player.id))
            if validDeclarations.contains(
                where: { validDeclaration in
                    validDeclaration.playerID == player.id && validDeclaration.actionID == .sidestep
                }
            ) {
                guard let playerSquare = player.square else {
                    throw GameError("Player is in reserves")
                }
                return Prompt(
                    coachID: coachID,
                    payload: .eligibleForReadyToGoBonusPlaySidestepAction(
                        playerID: player.id,
                        in: playerSquare
                    )
                )
            }
        }

        for player in players where player.isProne != nil {
            history.append(.eligibleForReadyToGoBonusPlayFreeAction(player.id))
            if validDeclarations.contains(
                where: { validDeclaration in
                    validDeclaration.playerID == player.id && validDeclaration.actionID == .standUp
                }
            ) {
                guard let playerSquare = player.square else {
                    throw GameError("Player is in reserves")
                }
                return Prompt(
                    coachID: coachID,
                    payload: .eligibleForReadyToGoBonusPlayStandUpAction(
                        playerID: player.id,
                        in: playerSquare
                    )
                )
            }
        }

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

    private func latestEligiblePlayerID() throws -> PlayerID {
        guard let playerID = try history.latestTurnContext().history.lastResult(
            { entry -> PlayerID? in
                guard case .eligibleForReadyToGoBonusPlayFreeAction(let playerID) = entry else {
                    return nil
                }
                return playerID
            }
        ) else {
            throw GameError("No player ID")
        }
        return playerID
    }

    mutating func useReadyToGoBonusPlayRunAction() throws -> Prompt? {
        return try declareRunAction(playerID: try latestEligiblePlayerID(), isFree: true)
    }

    mutating func declineReadyToGoBonusPlayRunAction() throws -> Prompt? {
        return try continueReadyToGoBonusPlay()
    }

    mutating func useReadyToGoBonusPlaySidestepAction() throws -> Prompt? {
        return try declareSidestepAction(playerID: try latestEligiblePlayerID(), isFree: true)
    }

    mutating func declineReadyToGoBonusPlaySidestepAction() throws -> Prompt? {
        return try continueReadyToGoBonusPlay()
    }

    mutating func useReadyToGoBonusPlayStandUpAction() throws -> Prompt? {
        return try declareStandUpAction(playerID: try latestEligiblePlayerID(), isFree: true)
    }

    mutating func declineReadyToGoBonusPlayStandUpAction() throws -> Prompt? {
        return try continueReadyToGoBonusPlay()
    }
}
