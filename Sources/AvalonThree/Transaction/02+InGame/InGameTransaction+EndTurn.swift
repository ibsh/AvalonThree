//
//  InGameTransaction+EndTurn.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/23/24.
//

import Foundation

extension InGameTransaction {

    mutating func endTurn() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard try !turnContext.actionContexts().contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        let oldTurnCoachID = turnContext.coachID
        let newTurnCoachID = oldTurnCoachID.inverse

        // check for sudden death end

        let coachScore = table.getScore(coachID: oldTurnCoachID)
        let opponentScore = table.getScore(coachID: newTurnCoachID)

        if
            !table.objectives.notEmpty.map({ $0.1 }).contains(where: { $0.challenge.isEndgame }),
            !table.discards.contains(where: { $0.challenge.isEndgame })
        {
            if coachScore + TableConstants.suddenDeathDelta <= opponentScore {
                events.append(.gameEnded(endConditions: .suddenDeath(coachID: newTurnCoachID)))
                return nil
            }
        }

        // check for clock end

        if turnContext.isFinal {
            if coachScore > opponentScore {
                events.append(.gameEnded(endConditions: .clock(coachID: oldTurnCoachID)))
            } else if opponentScore > coachScore {
                events.append(.gameEnded(endConditions: .clock(coachID: newTurnCoachID)))
            } else {
                events.append(.gameEnded(endConditions: .tie))
            }
            return nil
        }

        // discard down

        let hand = table.getHand(coachID: oldTurnCoachID)
        if hand.count > TableConstants.maxHandCount {
            return AddressedPrompt(
                coachID: oldTurnCoachID,
                prompt: .selectCardsToDiscardFromHand(
                    cards: hand,
                    count: hand.count - TableConstants.maxHandCount
                )
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
                    .playerCanTakeActions(playerID: player.id, playerSquare: player.square)
                )
            }
        }

        // remove turn-long bonuses

        let activeCards = table.getActiveBonuses(coachID: oldTurnCoachID)
        for activeCard in activeCards {
            switch activeCard.bonusPlay.persistence {
            case .oneAction,
                 .oneTurn:
                try discardActiveBonusPlay(
                    card: activeCard,
                    coachID: oldTurnCoachID
                )
            case .custom,
                 .game:
                break
            }
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
