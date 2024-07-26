//
//  InGameTransaction+BeginTurn.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func beginTurn() throws -> Prompt? {

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

        try newBall()

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

        if turnContext.isFirst {
            events.append(.gameStarted)
        }

        if turnContext.isFinal {
            events.append(.finalTurnBegan)
        }

        return try Prompt(
            coachID: turnContext.coachID,
            payload: .declarePlayerAction(
                validDeclarations: validDeclarations(),
                playerActionsLeft: playerActionsLeft()
            )
        )
    }

    private mutating func checkForDefensivePlayBonusPlay(
        turnContext: TurnContext
    ) throws -> Prompt? {

        if turnContext.history.contains(.eligibleForDefensivePlayBonusPlay) {
            return nil
        }

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .defensivePlay }
            )
        else {
            return nil
        }

        history.append(.eligibleForDefensivePlayBonusPlay)

        return Prompt(
            coachID: turnContext.coachID,
            payload: .eligibleForDefensivePlayBonusPlay
        )
    }

    private mutating func checkForPassingPlayBonusPlay(
        turnContext: TurnContext
    ) throws -> Prompt? {

        if turnContext.history.contains(.eligibleForPassingPlayBonusPlay) {
            return nil
        }

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .passingPlay }
            )
        else {
            return nil
        }

        history.append(.eligibleForPassingPlayBonusPlay)

        return Prompt(
            coachID: turnContext.coachID,
            payload: .eligibleForPassingPlayBonusPlay
        )
    }

    private mutating func checkForDiscardObjectives(
        turnContext: TurnContext
    ) throws -> Prompt? {

        if turnContext.isFirstOrSecond {
            return nil
        }

        if turnContext.history.contains(where: { entry in
            guard case .discardedObjective = entry else { return false }
            return true
        }) {
            return nil
        }

        let objectiveIDs = table.objectives.notEmpty.map { $0.0 }

        guard
            turnContext.mustDiscardObjective,
            !objectiveIDs.isEmpty
        else {
            return nil
        }

        history.append(
            .choosingObjectiveToDiscard(objectiveIDs: objectiveIDs)
        )

        if objectiveIDs.count == 1 {
            let objectiveID = objectiveIDs.first!
            history.append(
                .discardedObjective(objectiveID: objectiveID)
            )
            guard let objective = table.objectives.getObjective(id: objectiveID) else {
                throw GameError("No objective")
            }
            table.objectives.remove(objectiveID)
            table.discards.append(objective)
            events.append(
                .discardedObjective(coachID: turnContext.coachID, objectiveID: objectiveID)
            )
            return nil
        }

        return Prompt(
            coachID: turnContext.coachID,
            payload: .selectObjectiveToDiscard(objectiveIDs: objectiveIDs)
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

        for newObjectiveID in objectives.deal(from: &deck) {
            events.append(.dealtNewObjective(objectiveID: newObjectiveID))
        }

        table.deck = deck
        table.objectives = objectives
    }

    private mutating func newBall() throws {

        if table.balls.isEmpty {
            try addNewBall()
        }
    }

    private mutating func checkForEmergencyReserves(
        turnContext: TurnContext
    ) throws -> Prompt? {

        if turnContext.history.contains(.declareEmergencyReservesAction) {
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
            history.append(.declareEmergencyReservesAction)
            return Prompt(
                coachID: turnContext.coachID,
                payload: .declareEmergencyReservesAction(validPlayers: validPlayers)
            )
        }

        return nil
    }

    private mutating func checkForGetInThereBonusPlay(
        turnContext: TurnContext
    ) throws -> Prompt? {

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
    ) throws -> Prompt? {

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

            return Prompt(
                coachID: coachID,
                payload: .eligibleForGetInThereBonusPlayReservesAction(playerID: playerID)
            )
        }

        return nil
    }

    private mutating func checkForRegenerationSkill(
        turnContext: TurnContext
    ) throws -> Prompt? {

        for proneRegeneratingPlayer in table
            .players(coachID: turnContext.coachID)
            .filter({ $0.spec.skills.contains(.regenerate) && $0.isProne != nil })
            .sorted(by: { $0.index < $1.index })
        {

            guard
                !turnContext.history.contains(
                    .eligibleForRegenerationSkillStandUpAction(playerID: proneRegeneratingPlayer.id)
                )
            else {
                continue
            }

            history.append(
                .eligibleForRegenerationSkillStandUpAction(playerID: proneRegeneratingPlayer.id)
            )

            return Prompt(
                coachID: proneRegeneratingPlayer.coachID,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: proneRegeneratingPlayer.id
                )
            )
        }

        return nil
    }

    private mutating func checkForJumpUpBonusPlay(
        turnContext: TurnContext
    ) throws -> Prompt? {

        if turnContext.history.contains(.eligibleForJumpUpBonusPlayStandUpAction) {
            return nil
        }

        let playerIDs = try table
            .players(coachID: turnContext.coachID)
            .filter {
                try playerCanDeclareAction(
                    player: $0,
                    actionID: .standUp
                ) == .canDeclare(
                    consumesBonusPlays: []
                )
            }
            .map { $0.id }
            .toSet()

        guard
            table.getHand(coachID: turnContext.coachID).contains(
                where: { $0.bonusPlay == .jumpUp }
            ),
            !playerIDs.isEmpty
        else {
            return nil
        }

        history.append(.eligibleForJumpUpBonusPlayStandUpAction)

        return Prompt(
            coachID: turnContext.coachID,
            payload: .eligibleForJumpUpBonusPlayStandUpAction(validPlayers: playerIDs)
        )
    }

    private mutating func checkForReservesBonusPlay(
        turnContext: TurnContext
    ) throws -> Prompt? {

        if turnContext.history.contains(.eligibleForReservesBonusPlayReservesAction) {
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

        history.append(.eligibleForReservesBonusPlayReservesAction)

        return Prompt(
            coachID: turnContext.coachID,
            payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: playerIDs)
        )
    }
}
