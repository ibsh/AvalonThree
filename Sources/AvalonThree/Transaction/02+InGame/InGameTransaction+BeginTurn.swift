//
//  InGameTransaction+BeginTurn.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func beginTurn() throws -> AddressedPrompt? {

        var turnContext = try history.latestTurnContext()

        guard try playerActionsTaken() == 0 else {
            throw GameError("This turn already has player actions")
        }

        if let prompt = try checkForDefensivePlayBonusPlay(turnContext: turnContext) {
            return prompt
        }

        if let prompt = try checkForPassingPlayBonusPlay(turnContext: turnContext) {
            return prompt
        }

        if let prompt = try checkForDiscardObjectives(turnContext: turnContext) {
            return prompt
        }

        dealObjectives(turnContext: turnContext)

        try newBall(turnContext: turnContext)

        // refresh context
        turnContext = try history.latestTurnContext()

        if let prompt = try checkForEmergencyReserves(turnContext: turnContext) {
            return prompt
        }

        if let prompt = try checkForGetInThereBonusPlay(turnContext: turnContext) {
            return prompt
        }

        if let prompt = try checkForRegenerationSkill(turnContext: turnContext) {
            return prompt
        }

        if let prompt = try checkForJumpUpBonusPlay(turnContext: turnContext) {
            return prompt
        }

        if let prompt = try checkForReservesBonusPlay(turnContext: turnContext) {
            return prompt
        }

        events.append(
            .turnBegan(coachID: turnContext.coachID, isFinal: turnContext.isFinal)
        )

        let validDeclarations = try validDeclarations()

        return try AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .declarePlayerAction(
                validDeclarations: validDeclarations.toPromptDeclarations(table: table),
                playerActionsLeft: playerActionsLeft()
            )
        )
    }

    private mutating func checkForDefensivePlayBonusPlay(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        let historyEntry = HistoryEntry.eligibleForDefensivePlayBonusPlay

        if turnContext.history.contains(historyEntry) {
            return nil
        }

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .defensivePlay }
            )
        else {
            return nil
        }

        history.append(historyEntry)

        return AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .eligibleForDefensivePlayBonusPlay
        )
    }

    private mutating func checkForPassingPlayBonusPlay(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        let historyEntry = HistoryEntry.eligibleForPassingPlayBonusPlay

        if turnContext.history.contains(historyEntry) {
            return nil
        }

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .passingPlay }
            )
        else {
            return nil
        }

        history.append(historyEntry)

        return AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .eligibleForPassingPlayBonusPlay
        )
    }

    private mutating func checkForDiscardObjectives(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        if turnContext.isFirstOrSecond {
            return nil
        }

        if turnContext.history.contains(where: { entry in
            guard case .discardedObjective = entry else { return false }
            return true
        }) {
            return nil
        }

        let notEmptyObjectives = table.objectives.notEmpty

        guard
            turnContext.mustDiscardObjective,
            !notEmptyObjectives.isEmpty
        else {
            return nil
        }

        history.append(
            .choosingObjectiveToDiscard(objectiveIndices: notEmptyObjectives.map { $0.0 })
        )

        if notEmptyObjectives.count == 1 {
            let objective = notEmptyObjectives.first!
            history.append(
                .discardedObjective(objectiveIndex: objective.0)
            )
            try table.objectives.remove(objective.0)
            table.discards.append(objective.1)
            events.append(
                .discardedObjective(
                    coachID: turnContext.coachID,
                    objectiveIndex: objective.0,
                    objective: objective.1,
                    objectives: table.objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
            )
            return nil
        }

        return AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .selectObjectiveToDiscard(
                objectives: table.objectives.toWrappedObjectives()
            )
        )
    }

    private mutating func dealObjectives(
        turnContext: TurnContext
    ) {

        if turnContext.isFirstOrSecond {
            return
        }

        var objectives = table.objectives
        var deck = table.deck

        if objectives.first == nil, let card = deck.popFirst() {
            objectives.first = card
            events.append(
                .dealtNewObjective(
                    coachID: turnContext.coachID,
                    objectiveIndex: 0,
                    objectives: objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDeck(
                    top: deck.first?.toWrappedObjective(),
                    count: deck.count
                )
            )
        }

        if objectives.second == nil, let card = deck.popFirst() {
            objectives.second = card
            events.append(
                .dealtNewObjective(
                    coachID: turnContext.coachID,
                    objectiveIndex: 1,
                    objectives: objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDeck(
                    top: deck.first?.toWrappedObjective(),
                    count: deck.count
                )
            )
        }

        if objectives.third == nil, let card = deck.popFirst() {
            objectives.third = card
            events.append(
                .dealtNewObjective(
                    coachID: turnContext.coachID,
                    objectiveIndex: 2,
                    objectives: objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDeck(
                    top: deck.first?.toWrappedObjective(),
                    count: deck.count
                )
            )
        }

        table.deck = deck
        table.objectives = objectives
    }

    private mutating func newBall(
        turnContext: TurnContext
    ) throws {

        if table.balls.isEmpty {
            try addNewBall(bounce: !turnContext.isFirst)
        }
    }

    private mutating func checkForEmergencyReserves(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        let historyEntry = HistoryEntry.declareEmergencyReservesAction

        if turnContext.history.contains(historyEntry) {
            return nil
        }

        guard
            !table.getActiveBonuses(
                coachID: turnContext.coachID.inverse
            ).contains(
                where: { $0.bonusPlay == .bribedRef
                }
            )
        else {
            return nil
        }

        let validPlayers = try table.players(coachID: turnContext.coachID)
            .filter(
                {
                    try playerCanDeclareAction(player: $0, actionID: .reserves)
                    == .canDeclare(consumesBonusPlays: [])
                }
            )
            .map { $0.id }
            .toSet()

        if validPlayers.count >= table.teamID(coachID: turnContext.coachID).spec.emergencyReserves {
            history.append(historyEntry)
            return AddressedPrompt(
                coachID: turnContext.coachID,
                prompt: .declareEmergencyReservesAction(validPlayers: validPlayers)
            )
        }

        return nil
    }

    private mutating func checkForGetInThereBonusPlay(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        if let prompt = try checkForGetInThereBonusPlay(
            turnContext: turnContext,
            coachID: turnContext.coachID
        ) {
            return prompt
        }

        if let prompt = try checkForGetInThereBonusPlay(
            turnContext: turnContext,
            coachID: turnContext.coachID.inverse
        ) {
            return prompt
        }

        return nil
    }

    private mutating func checkForGetInThereBonusPlay(
        turnContext: TurnContext,
        coachID: CoachID
    ) throws -> AddressedPrompt? {

        let bonusPlay = BonusPlay.getInThere

        guard table.getHand(coachID: coachID).contains(
            where: { $0.bonusPlay == bonusPlay }
        ) else { return nil }

        let playerIDs = turnContext.history.compactMap { entry -> PlayerID? in
            guard case .playerInjured(let playerID) = entry else { return nil }
            return playerID
        }

        let validDeclarations = try validDeclarations(coachID: coachID)

        for playerID in playerIDs {
            let historyEntry = HistoryEntry.eligibleForGetInThereBonusPlayReservesAction(playerID)
            guard
                !turnContext.history.contains(historyEntry),
                playerID.coachID == coachID,
                validDeclarations.contains(where: { validDeclaration in
                    validDeclaration.playerID == playerID
                    && validDeclaration.actionID == .reserves
                })
            else {
                continue
            }

            history.append(historyEntry)

            return AddressedPrompt(
                coachID: coachID,
                prompt: .eligibleForGetInThereBonusPlayReservesAction(playerID: playerID)
            )
        }

        return nil
    }

    private mutating func checkForRegenerationSkill(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        for proneRegeneratingPlayer in table
            .players(coachID: turnContext.coachID)
            .filter({ $0.spec.skills.contains(.regenerate) && $0.isProne != nil })
            .sorted(by: { $0.index < $1.index })
        {

            let historyEntry = HistoryEntry.eligibleForRegenerationSkillStandUpAction(
                playerID: proneRegeneratingPlayer.id
            )

            guard
                !turnContext.history.contains(historyEntry)
            else {
                continue
            }

            history.append(historyEntry)

            guard let playerSquare = proneRegeneratingPlayer.square else {
                throw GameError("Player is in reserves")
            }

            return AddressedPrompt(
                coachID: proneRegeneratingPlayer.coachID,
                prompt: .eligibleForRegenerationSkillStandUpAction(
                    player: PromptBoardPlayer(
                        id: proneRegeneratingPlayer.id,
                        square: playerSquare
                    )
                )
            )
        }

        return nil
    }

    private mutating func checkForJumpUpBonusPlay(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        let historyEntry = HistoryEntry.eligibleForJumpUpBonusPlayStandUpAction

        if turnContext.history.contains(historyEntry) {
            return nil
        }

        let players = try table
            .players(coachID: turnContext.coachID)
            .filter {
                try playerCanDeclareAction(
                    player: $0,
                    actionID: .standUp
                ) == .canDeclare(
                    consumesBonusPlays: []
                )
            }
            .toSet()

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .jumpUp }
            ),
            !players.isEmpty
        else {
            return nil
        }

        history.append(historyEntry)

        return AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .eligibleForJumpUpBonusPlayStandUpAction(
                validPlayers: try players.map { player in
                    guard let playerSquare = player.square else {
                        throw GameError("Player is in reserves")
                    }
                    return PromptBoardPlayer(
                        id: player.id,
                        square: playerSquare
                    )
                }.toSet()
            )
        )
    }

    private mutating func checkForReservesBonusPlay(
        turnContext: TurnContext
    ) throws -> AddressedPrompt? {

        let historyEntry = HistoryEntry.eligibleForReservesBonusPlayReservesAction

        if turnContext.history.contains(historyEntry) {
            return nil
        }

        let playerIDs = try table
            .players(coachID: turnContext.coachID)
            .filter {
                try playerCanDeclareAction(
                    player: $0,
                    actionID: .reserves
                ) == .canDeclare(
                    consumesBonusPlays: []
                )
            }
            .map { $0.id }
            .toSet()

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .reserves }
            ),
            !playerIDs.isEmpty
        else {
            return nil
        }

        history.append(historyEntry)

        return AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .eligibleForReservesBonusPlayReservesAction(validPlayers: playerIDs)
        )
    }
}
