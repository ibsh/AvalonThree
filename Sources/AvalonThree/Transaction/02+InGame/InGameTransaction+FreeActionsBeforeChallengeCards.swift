//
//  InGameTransaction+FreeActionsBeforeChallengeCards.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func checkForFreeActionsBeforeChallengeCards() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()
        let actionContexts = try turnContext.actionContexts()

        guard !actionContexts.contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        guard let lastActionContext = actionContexts.last else {
            return nil
        }

        // MARK: - This coach

        if let prompt = try checkForFrenzied(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForShoulderCharge(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForDivingTackle(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForHeadbutt(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForBlitz(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForComboPlay(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForGetInThereBonusPlay(
            turnContext,
            lastActionContext,
            turnContext.coachID
        ) {
            return prompt
        }

        // MARK: - Other coach

        if let prompt = try checkForDistraction(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForIntervention(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForGetInThereBonusPlay(
            turnContext,
            lastActionContext,
            turnContext.coachID.inverse
        ) {
            return prompt
        }

        return nil
    }

    private mutating func checkForFrenzied(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .mark else {
            return nil
        }

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        guard
            player.spec.skills.contains(.frenzied),
            try playerCanDeclareAction(
                player: player,
                actionID: .block
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            return nil
        }

        let historyEntry = HistoryEntry.eligibleForFrenziedSkillBlockAction(
            playerID: lastActionContext.playerID
        )

        guard !lastActionContext.history.contains(historyEntry) else { return nil }

        history.append(historyEntry)

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        return AddressedPrompt(
            coachID: player.coachID,
            prompt: .eligibleForFrenziedSkillBlockAction(
                player: PromptBoardPlayer(
                    id: player.id,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForShoulderCharge(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .mark else {
            return nil
        }

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        guard
            table.getHand(coachID: lastActionContext.coachID).contains(
                where: { $0.bonusPlay == .shoulderCharge }
            ),
            try playerCanDeclareAction(
                player: player,
                actionID: .block
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            return nil
        }

        let historyEntry = HistoryEntry.eligibleForShoulderChargeBonusPlayBlockAction(
            playerID: lastActionContext.playerID
        )

        guard !lastActionContext.history.contains(historyEntry) else { return nil }

        history.append(historyEntry)

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        return AddressedPrompt(
            coachID: lastActionContext.coachID,
            prompt: .eligibleForShoulderChargeBonusPlayBlockAction(
                player: PromptBoardPlayer(
                    id: player.id,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForDivingTackle(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .mark else {
            return nil
        }

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        guard
            table.getHand(coachID: lastActionContext.coachID).contains(
                where: { $0.bonusPlay == .divingTackle }
            ),
            try playerCanDeclareAction(
                player: player,
                actionID: .block
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            return nil
        }

        let historyEntry = HistoryEntry.eligibleForDivingTackleBonusPlayBlockAction(
            playerID: lastActionContext.playerID
        )

        guard !lastActionContext.history.contains(historyEntry) else { return nil }

        history.append(historyEntry)

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        return AddressedPrompt(
            coachID: lastActionContext.coachID,
            prompt: .eligibleForDivingTackleBonusPlayBlockAction(
                player: PromptBoardPlayer(
                    id: player.id,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForHeadbutt(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .mark else {
            return nil
        }

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        guard
            player.spec.skills.contains(.headbutt),
            try turnContext.actionContexts().contains(where: { actionContext in
                actionContext.playerID == player.id
                && actionContext.actionID == .run
                && actionContext.isFinished
            }),
            try playerCanDeclareAction(
                player: player,
                actionID: .block
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            return nil
        }

        let historyEntry = HistoryEntry.eligibleForHeadbuttSkillBlockAction(
            playerID: lastActionContext.playerID
        )

        guard !lastActionContext.history.contains(historyEntry) else { return nil }

        history.append(historyEntry)

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        return AddressedPrompt(
            coachID: player.coachID,
            prompt: .eligibleForHeadbuttSkillBlockAction(
                player: PromptBoardPlayer(
                    id: lastActionContext.playerID,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForBlitz(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .mark else {
            return nil
        }

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        let bonusPlay = BonusPlay.blitz

        guard
            table.getHand(coachID: lastActionContext.coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: lastActionContext.coachID, bonusPlay: bonusPlay)
            ),
            try turnContext.actionContexts().contains(
                where: { $0.playerID == player.id && $0.actionID == .run }
            ),
            try playerCanDeclareAction(
                player: player,
                actionID: .block
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            return nil
        }

        let historyEntry = HistoryEntry.eligibleForBlitzBonusPlayBlockAction(
            playerID: lastActionContext.playerID
        )

        guard !lastActionContext.history.contains(historyEntry) else { return nil }

        history.append(historyEntry)

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        return AddressedPrompt(
            coachID: lastActionContext.coachID,
            prompt: .eligibleForBlitzBonusPlayBlockAction(
                player: PromptBoardPlayer(
                    id: player.id,
                    square: playerSquare
                )
            )
        )
    }

    private mutating func checkForComboPlay(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .pass else {
            return nil
        }

        let allValidDeclarations = try validDeclarations()

        let bonusPlay = BonusPlay.comboPlay

        guard
            table.getHand(coachID: lastActionContext.coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: lastActionContext.coachID, bonusPlay: bonusPlay)
            ),
            let passTarget = history.lastResult({ entry -> PassTarget? in
                guard case .passTarget(let passTarget) = entry else { return nil }
                return passTarget
            }),
            lastActionContext.history.contains(where: { entry in
                guard case .passSuccessful = entry else { return false }
                return true
            }),
            !lastActionContext.history.contains(where: { entry in
                guard case .eligibleForComboPlayBonusPlayFreeAction = entry else { return false }
                return true
            })
        else {
            return nil
        }

        let relevantValidDeclarations = allValidDeclarations.filter({ validDeclaration in
            validDeclaration.playerID == passTarget.targetPlayer.id
            && [.run, .sidestep].contains(validDeclaration.actionID)
        })

        guard relevantValidDeclarations.count == 1 else {
            return nil
        }

        let validDeclaration = relevantValidDeclarations.first!

        history.append(
            .eligibleForComboPlayBonusPlayFreeAction(validDeclaration: validDeclaration)
        )

        return AddressedPrompt(
            coachID: lastActionContext.coachID,
            prompt: .eligibleForComboPlayBonusPlayFreeAction(
                validDeclaration: validDeclaration.toPromptDeclaration(),
                playerSquare: try {
                    guard let playerSquare = table.getPlayer(id: validDeclaration.playerID)?.square else {
                        throw GameError("Player is in reserves")
                    }
                    return playerSquare
                }()
            )
        )
    }

    private mutating func checkForGetInThereBonusPlay(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext,
        _ coachID: CoachID
    ) throws -> AddressedPrompt? {

        let bonusPlay = BonusPlay.getInThere

        guard
            table.getHand(coachID: coachID).contains(where: { $0.bonusPlay == bonusPlay }),
            !turnContext.history.contains(.usedBonusPlay(coachID: coachID, bonusPlay: bonusPlay))
        else { return nil }

        let playerIDs = lastActionContext.history.compactMap { entry -> PlayerID? in
            guard case .playerInjured(let playerID) = entry else { return nil }
            return playerID
        }

        let validDeclarations = try validDeclarations(coachID: coachID)

        for playerID in playerIDs {
            guard
                !turnContext.history.contains(
                    .eligibleForGetInThereBonusPlayReservesAction(playerID)
                ),
                playerID.coachID == coachID,
                validDeclarations.contains(where: { validDeclaration in
                    validDeclaration.playerID == playerID
                    && validDeclaration.actionID == .reserves
                })
            else {
                continue
            }

            history.append(.eligibleForGetInThereBonusPlayReservesAction(playerID))

            return AddressedPrompt(
                coachID: coachID,
                prompt: .eligibleForGetInThereBonusPlayReservesAction(playerID: playerID)
            )
        }

        return nil
    }

    private mutating func checkForDistraction(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        let coachID = turnContext.coachID.inverse

        let bonusPlay = BonusPlay.distraction

        guard
            table.getHand(coachID: coachID).contains(where: { $0.bonusPlay == bonusPlay }),
            !turnContext.history.contains(.usedBonusPlay(coachID: coachID, bonusPlay: bonusPlay)),
            let lastActionContext = try turnContext.actionContexts().last,
            lastActionContext.actionID == .mark,
            lastActionContext.coachID == turnContext.coachID,
            let player = table.getPlayer(id: lastActionContext.playerID),
            let playerSquare = table.playerIsMarked(player)
        else {
            return nil
        }

        guard
            !lastActionContext.history.contains(
                where: { entry in
                    guard case .eligibleForDistractionBonusPlaySidestepAction = entry else {
                        return false
                    }
                    return true
                }
            )
        else {
            return nil
        }

        let validDeclarations = try validDeclarations(coachID: coachID)
        let validPlayerIDs = validDeclarations.compactMap { validDeclaration -> PlayerID? in
            guard
                validDeclaration.actionID == .sidestep,
                let myPlayer = table.getPlayer(id: validDeclaration.playerID),
                let myPlayerSquare = myPlayer.square,
                myPlayerSquare.isAdjacent(to: playerSquare)
            else { return nil }
            return validDeclaration.playerID
        }
            .toSet()

        if validPlayerIDs.isEmpty {
            return nil
        }

        history.append(.eligibleForDistractionBonusPlaySidestepAction(validPlayerIDs))

        return AddressedPrompt(
            coachID: coachID,
            prompt: .eligibleForDistractionBonusPlaySidestepAction(
                validPlayers: try validPlayerIDs.map { playerID in
                    guard let playerSquare = table.getPlayer(id: playerID)?.square else {
                        throw GameError("Player is in reserves")
                    }
                    return PromptBoardPlayer(
                        id: playerID,
                        square: playerSquare
                    )
                }.toSet()
            )
        )
    }

    private mutating func checkForIntervention(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        let coachID = turnContext.coachID.inverse

        let bonusPlay = BonusPlay.intervention

        guard
            table.getHand(coachID: coachID).contains(
                where: { $0.bonusPlay == bonusPlay }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: lastActionContext.coachID, bonusPlay: bonusPlay)
            ),
            let lastActionContext = try turnContext.actionContexts().last,
            lastActionContext.actionID == .run,
            lastActionContext.coachID == turnContext.coachID,
            let targetPlayer = table.getPlayer(id: lastActionContext.playerID)
        else {
            return nil
        }

        guard
            !lastActionContext.history.contains(
                where: { entry in
                    guard case .eligibleForInterventionBonusPlayMarkAction = entry else {
                        return false
                    }
                    return true
                }
            )
        else {
            return nil
        }

        let allDeclarations = try validDeclarations(coachID: coachID)
        let validDeclarations = try allDeclarations.filter { declaration in
            guard
                declaration.actionID == .mark,
                let myPlayer = table.getPlayer(id: declaration.playerID),
                try opponentsThatCanBeMarked(
                    player: myPlayer,
                    maxMarkDistance: declaration.consumesBonusPlays.contains(.interference)
                        ? TableConstants.interferenceBonusPlayMaxMarkDistance
                        : TableConstants.maxMarkDistance
                )
                .contains(targetPlayer.id)
            else { return false }
            return true
        }

        if validDeclarations.isEmpty {
            return nil
        }

        history.append(
            .eligibleForInterventionBonusPlayMarkAction(validDeclarations, target: targetPlayer.id)
        )

        return AddressedPrompt(
            coachID: coachID,
            prompt: .eligibleForInterventionBonusPlayMarkAction(
                validDeclarations: validDeclarations.toPromptDeclarations(table: table)
            )
        )
    }
}
