//
//  InGameTransaction+InputMessage+ChooseCardsToDiscardFromHand.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Foundation

extension InGameTransaction {

    mutating func selectCardsToDiscardFromHand(
        cards: [ChallengeCard]
    ) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        guard try !turnContext.actionContexts().contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        let hand = table.getHand(coachID: turnContext.coachID)
        guard hand.count > TableConstants.maxHandCount else {
            throw GameError("No need to discard")
        }

        guard !cards.contains(where: { !hand.contains($0) }) else {
            throw GameError("Invalid cards")
        }

        let newHand = hand.filter { !cards.contains($0) }

        guard newHand.count == TableConstants.maxHandCount else {
            throw GameError("Invalid card count")
        }

        table.setHand(
            coachID: turnContext.coachID,
            hand: newHand
        )
        table.discards.append(contentsOf: cards)

        events.append(
            .discardedCardsFromHand(
                coachID: turnContext.coachID,
                cards: cards
            )
        )

        return try endTurn()
    }
}
