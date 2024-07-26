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
                events.append(.playerCanTakeActions(playerID: player.id))
            }
        }

        // remove turn-long bonuses

        let activeBonuses = table.getActiveBonuses(coachID: oldTurnCoachID)
        var maintainBonuses = [ChallengeCard]()
        var discardBonuses = [ChallengeCard]()
        for activeBonus in activeBonuses {
            switch activeBonus.bonusPlay.persistence {
            case .instant,
                 .oneAction,
                 .oneTurn:
                discardBonuses.append(activeBonus)
            case .custom,
                 .game:
                maintainBonuses.append(activeBonus)
            }
        }
        table.setActiveBonuses(coachID: oldTurnCoachID, activeBonuses: maintainBonuses)
        table.discards.append(contentsOf: discardBonuses)
        for discardBonus in discardBonuses {
            events.append(
                .discardedPersistentBonusPlay(
                    coachID: oldTurnCoachID,
                    bonusPlay: discardBonus.bonusPlay
                )
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
