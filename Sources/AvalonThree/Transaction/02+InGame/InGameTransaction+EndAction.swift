//
//  InGameTransaction+EndAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func endAction() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()
        let actionContexts = try turnContext.actionContexts()

        guard !actionContexts.contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        // remove action-long bonuses

        if let actionContext = actionContexts.last {
            try removeActionLongBonuses(
                actionContext: actionContext,
                coachID: actionContext.coachID
            )
            try removeActionLongBonuses(
                actionContext: actionContext,
                coachID: actionContext.coachID.inverse
            )
        }

        // Check for free actions that happen before the claim challenge card step

        if let prompt = try checkForFreeActionsBeforeChallengeCards() {
            return prompt
        }

        // Check for objectives that are claimed before touchdowns (if not first turn)

        if !turnContext.isFirst {
            if let prompt = try checkObjectives(postTouchdown: false) {
                return prompt
            }
        }

        // Check for touchdowns

        let scoringPlayersAndBalls = table.playersInSquares(
            Square.endZoneSquares(coachID: turnContext.coachID.inverse)
        )
            .compactMap({ player -> (Player, Square, Ball)? in
                guard
                    player.coachID == turnContext.coachID,
                    let square = table.playerIsOpen(player),
                    let ball = table.playerHasABall(player)
                else {
                    return nil
                }
                return (player, square, ball)
            })

        for (scoringPlayer, square, ball) in scoringPlayersAndBalls {
            var scoringPlayer = scoringPlayer
            scoringPlayer.state = .inReserves
            table.players.update(with: scoringPlayer)
            table.incrementScore(
                coachID: turnContext.coachID,
                increment: TableConstants.touchdownScoreValue
            )
            history.append(.touchdown)
            table.balls.remove(ball)

            events.append(
                .playerScoredTouchdown(
                    playerID: scoringPlayer.id,
                    playerSquare: square,
                    ballID: ball.id
                )
            )
            events.append(
                .scoreUpdated(
                    coachID: scoringPlayer.coachID,
                    increment: TableConstants.touchdownScoreValue,
                    total: table.getScore(coachID: scoringPlayer.coachID)
                )
            )

            try checkForLegUpBonusPlay()
        }

        // Check for objectives that are claimed after touchdowns (if not first turn)

        if !turnContext.isFirst {
            if let prompt = try checkObjectives(postTouchdown: true) {
                return prompt
            }
        }

        // Check for free actions that happen after the claim challenge card step

        if let prompt = try checkForFreeActionsAfterChallengeCards() {
            return prompt
        }

        let playerActionsTaken = try playerActionsTaken()

        if table.getActiveBonuses(coachID: turnContext.coachID).contains(
            where: { $0.bonusPlay == .readyToGo }
        ) {
            return try continueReadyToGoBonusPlay()
        }

        if table.getActiveBonuses(coachID: turnContext.coachID).contains(
            where: { $0.bonusPlay == .yourTimeToShine }
        ) {
            return try continueYourTimeToShineBonusPlay()
        }

        // Is turn still starting?

        if playerActionsTaken == 0 {
            return try beginTurn()
        }

        // Is turn still ongoing?

        let validDeclarations = try validDeclarations()
        if playerActionsTaken < TableConstants.maxPlayerActionsPerTurn,
            !validDeclarations.isEmpty
        {
            return try AddressedPrompt(
                coachID: turnContext.coachID,
                prompt: .declarePlayerAction(
                    validDeclarations: validDeclarations.toPromptDeclarations(table: table),
                    playerActionsLeft: playerActionsLeft()
                )
            )
        }

        return try endTurn()
    }

    private mutating func removeActionLongBonuses(
        actionContext: ActionContext,
        coachID: CoachID
    ) throws {
        let activeCards = table.getActiveBonuses(coachID: coachID)
        for activeCard in activeCards {
            switch activeCard.bonusPlay.persistence {
            case .oneAction:
                try discardActiveBonusPlay(
                    card: activeCard,
                    coachID: coachID
                )
            case .oneTurn,
                 .custom,
                 .game:
                break
            }
        }
    }
}
