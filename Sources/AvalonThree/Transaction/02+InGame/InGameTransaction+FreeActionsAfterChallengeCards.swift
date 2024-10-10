//
//  InGameTransaction+FreeActionsAfterChallengeCards.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func checkForFreeActionsAfterChallengeCards() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()
        let actionContexts = try turnContext.actionContexts()

        guard !actionContexts.contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        guard
            let lastActionContext = actionContexts.last(where: { actionContext in
                actionContext.coachID == turnContext.coachID
            })
        else {
            return nil
        }

        if let prompt = try checkForCatchersInstincts(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForInspiration(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForShadow(turnContext, lastActionContext) {
            return prompt
        }

        if let prompt = try checkForGetInThereBonusPlay(
            turnContext,
            lastActionContext,
            turnContext.coachID
        ) {
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

    private mutating func checkForCatchersInstincts(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        guard lastActionContext.actionID == .pass else {
            return nil
        }

        var success = false
        var distance: PassDistance?
        var targetPlayerID: PlayerID?

        for entry in lastActionContext.history {
            switch entry {
            case .passTarget(let target):
                targetPlayerID = target.targetPlayer.id
                distance = target.distance
            case .passSuccessful:
                success = true
            default:
                break
            }
        }

        guard
            success,
            let distance,
            let targetPlayerID
        else { return nil }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetPlayerSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        guard
            targetPlayer.spec.skills.contains(.catchersInstincts),
            distance != .handoff,
            try playerCanDeclareAction(
                player: targetPlayer,
                actionID: .run
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            return nil
        }

        guard
            !lastActionContext.history.contains(
                where: { entry in
                    guard case .eligibleForCatchersInstinctsSkillRunAction = entry else {
                        return false
                    }
                    return true
                }
            )
        else {
            return nil
        }

        history.append(
            .eligibleForCatchersInstinctsSkillRunAction(playerID: targetPlayerID)
        )

        return AddressedPrompt(
            coachID: targetPlayer.coachID,
            prompt: .eligibleForCatchersInstinctsSkillRunAction(
                player: PromptBoardPlayer(
                    id: targetPlayerID,
                    square: targetPlayerSquare
                )
            )
        )
    }

    private mutating func checkForInspiration(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        let validDeclarations = try validDeclarations()

        guard
            table.getHand(coachID: lastActionContext.coachID).contains(
                where: { $0.bonusPlay == .inspiration }
            ),
            !validDeclarations.isEmpty,
            try playerActionsTaken() == TableConstants.maxPlayerActionsPerTurn
        else {
            return nil
        }

        guard
            !turnContext.history.contains(
                .eligibleForInspirationBonusPlayFreeAction
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: lastActionContext.coachID, bonusPlay: .inspiration)
            )
        else {
            return nil
        }

        history.append(
            .eligibleForInspirationBonusPlayFreeAction
        )

        return AddressedPrompt(
            coachID: lastActionContext.coachID,
            prompt: .eligibleForInspirationBonusPlayFreeAction(
                validDeclarations: validDeclarations.toPromptDeclarations(table: table)
            )
        )
    }

    private mutating func checkForShadow(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> AddressedPrompt? {

        let coachID = turnContext.coachID.inverse

        guard
            table.getHand(coachID: coachID).contains(
                where: { $0.bonusPlay == .shadow }
            ),
            let lastActionContext = try turnContext.actionContexts().last,
            lastActionContext.coachID == turnContext.coachID,
            lastActionContext.actionID == .sidestep
        else {
            return nil
        }

        guard
            !lastActionContext.history.contains(where: { entry in
                guard case .eligibleForShadowBonusPlayExtraMove = entry else { return false }
                return true
            })
        else {
            return nil
        }

        guard
            let square = lastActionContext
                .snapshot
                .players
                .first(where: { $0.id == lastActionContext.playerID })?.square
        else {
            throw GameError("No square")
        }

        let validPlayers = table
            .players(coachID: coachID)
            .filter { player in
                player.square?.isAdjacent(to: square) == true
            }
            .toSet()

        if validPlayers.isEmpty {
            return nil
        }

        history.append(
            .eligibleForShadowBonusPlayExtraMove(
                validPlayers: validPlayers.map { $0.id }.toSet(),
                square: square
            )
        )

        return AddressedPrompt(
            coachID: coachID,
            prompt: .eligibleForShadowBonusPlayExtraMove(
                validPlayers: try validPlayers.map { player in
                    guard let playerSquare = player.square else {
                        throw GameError("Player is in reserves")
                    }
                    return PromptBoardPlayer(
                        id: player.id,
                        square: playerSquare
                    )
                }.toSet(),
                square: square
            )
        )
    }

    private mutating func checkForGetInThereBonusPlay(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext,
        _ coachID: CoachID
    ) throws -> AddressedPrompt? {

        let bonusPlay = BonusPlay.getInThere

        guard table.getHand(coachID: coachID).contains(
            where: { $0.bonusPlay == bonusPlay }
        ) else { return nil }

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
}
