//
//  InGameTransaction+EndTurn.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/23/24.
//

import Foundation

extension InGameTransaction {

    mutating func endTurn() throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        guard try !turnContext.actionContexts().contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        let oldTurnCoachID = turnContext.coachID
        let newTurnCoachID = oldTurnCoachID.inverse

        // check for sudden death end

        let coachScore = table.getScore(coachID: oldTurnCoachID)
        let opponentScore = table.getScore(coachID: newTurnCoachID)

        if coachScore + TableConstants.suddenDeathDelta <= opponentScore {
            events.append(.gameEnded(endConditions: .suddenDeath(newTurnCoachID)))
            return nil
        }

        // check for clock end

        if turnContext.isFinal {
            if coachScore > opponentScore {
                events.append(.gameEnded(endConditions: .clock(oldTurnCoachID)))
            } else if opponentScore > coachScore {
                events.append(.gameEnded(endConditions: .clock(newTurnCoachID)))
            } else {
                events.append(.gameEnded(endConditions: .tie))
            }
            return nil
        }

        // discard down

        let hand = table.getHand(coachID: oldTurnCoachID)
        if hand.count > TableConstants.maxHandCount {
            return Prompt(
                coachID: oldTurnCoachID,
                payload: .selectCardsToDiscardFromHand(cards: hand)
            )
        }

        // get ready to end turn

        let oldTurnWasFirst = turnContext.isFirst
        let newTurnIsFinal = table.deck.isEmpty
        let mustDiscardObjective = !turnContext.history.contains { entry in
            guard case .claimedObjective = entry else { return false }
            return true
        }

        // end turn

        events.append(.turnEnded(coachID: oldTurnCoachID))

        // refresh disabled players

        table.players.forEach { player in
            if !player.canTakeActions {
                var player = player
                player.canTakeActions = true
                table.players.update(with: player)
                events.append(
                    .playerCanTakeActions(playerID: player.id, in: player.square)
                )
            }
        }

        // remove turn-long bonuses

        let activeBonusCards = table.getActiveBonuses(coachID: oldTurnCoachID)
        var maintainCards = [ChallengeCard]()
        var discardCards = [ChallengeCard]()
        for activeBonusCard in activeBonusCards {
            switch activeBonusCard.bonusPlay.persistence {
            case .instant,
                 .oneAction,
                 .oneTurn:
                discardCards.append(activeBonusCard)
            case .custom,
                 .game:
                maintainCards.append(activeBonusCard)
            }
        }
        table.setActiveBonuses(coachID: oldTurnCoachID, activeBonuses: maintainCards)
        for discardCard in discardCards {
            table.discards.append(discardCard)
            events.append(
                .discardedPersistentBonusPlay(
                    coachID: oldTurnCoachID,
                    card: discardCard
                )
            )
            events.append(
                .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
            )
        }

        history.append(
            .prepareForTurn(
                coachID: newTurnCoachID,
                isSpecial: {
                    if oldTurnWasFirst {
                        .second
                    } else if newTurnIsFinal {
                        .final
                    } else {
                        nil
                    }
                }(),
                mustDiscardObjective: mustDiscardObjective
            )
        )

        return try beginTurn()
    }
}
