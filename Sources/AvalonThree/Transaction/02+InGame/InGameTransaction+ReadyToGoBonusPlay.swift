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

    mutating func continueReadyToGoBonusPlay() throws -> AddressedPrompt? {

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
                return AddressedPrompt(
                    coachID: coachID,
                    prompt: .eligibleForReadyToGoBonusPlayRunAction(
                        playerID: player.id,
                        playerSquare: playerSquare
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
                return AddressedPrompt(
                    coachID: coachID,
                    prompt: .eligibleForReadyToGoBonusPlaySidestepAction(
                        playerID: player.id,
                        playerSquare: playerSquare
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
                return AddressedPrompt(
                    coachID: coachID,
                    prompt: .eligibleForReadyToGoBonusPlayStandUpAction(
                        playerID: player.id,
                        playerSquare: playerSquare
                    )
                )
            }
        }

        guard
            let card = table
                .getActiveBonuses(coachID: coachID)
                .first(where: { $0.bonusPlay == bonusPlay })
        else {
            throw GameError("No active bonus")
        }
        try discardActiveBonusPlay(card: card, coachID: coachID)

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

    mutating func useReadyToGoBonusPlayRunAction() throws -> AddressedPrompt? {
        return try declareRunAction(playerID: try latestEligiblePlayerID(), isFree: true)
    }

    mutating func declineReadyToGoBonusPlayRunAction() throws -> AddressedPrompt? {
        return try continueReadyToGoBonusPlay()
    }

    mutating func useReadyToGoBonusPlaySidestepAction() throws -> AddressedPrompt? {
        return try declareSidestepAction(playerID: try latestEligiblePlayerID(), isFree: true)
    }

    mutating func declineReadyToGoBonusPlaySidestepAction() throws -> AddressedPrompt? {
        return try continueReadyToGoBonusPlay()
    }

    mutating func useReadyToGoBonusPlayStandUpAction() throws -> AddressedPrompt? {
        return try declareStandUpAction(playerID: try latestEligiblePlayerID(), isFree: true)
    }

    mutating func declineReadyToGoBonusPlayStandUpAction() throws -> AddressedPrompt? {
        return try continueReadyToGoBonusPlay()
    }
}
