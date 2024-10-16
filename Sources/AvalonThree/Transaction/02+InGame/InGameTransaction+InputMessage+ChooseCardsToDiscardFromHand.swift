//
//  InGameTransaction+InputMessage+ChooseCardsToDiscardFromHand.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Foundation

extension InGameTransaction {

    mutating func selectCardsToDiscardFromHand(
        cards: Set<ChallengeCard>
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard try !turnContext.actionContexts().contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        let hand = table.getHand(coachID: turnContext.coachID)
        guard hand.count > TableConstants.maxHandCount else {
            throw GameError("No need to discard")
        }

        guard cards.isSubset(of: hand) else {
            throw GameError("Invalid cards")
        }

        var newHand = hand

        for card in hand {
            guard cards.contains(card) else { continue }
            _ = newHand.removeFirst(where: { $0 == card })
            events.append(
                .discardedCardFromHand(
                    coachID: turnContext.coachID,
                    card: card,
                    hand: newHand.map { .open(card: $0) },
                    active: table.getActiveBonuses(coachID: turnContext.coachID)
                )
            )
            table.discards.append(card)
            events.append(
                .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
            )
        }

        table.setHand(
            coachID: turnContext.coachID,
            hand: newHand
        )

        guard newHand.count == TableConstants.maxHandCount else {
            throw GameError("Invalid card count")
        }

        return try endTurn()
    }
}
