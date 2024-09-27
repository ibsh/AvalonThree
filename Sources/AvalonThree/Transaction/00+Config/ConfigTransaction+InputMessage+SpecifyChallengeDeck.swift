//
//  ConfigTransaction+InputMessage+SpecifyChallengeDeck.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func specifyChallengeDeck(
        challengeDeckID: ChallengeDeckID
    ) throws -> Prompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Coin has not been flipped yet")
        }

        guard config.boardSpecID != nil else {
            throw GameError("Board spec has not been specified yet")
        }

        guard config.challengeDeckID == nil else {
            throw GameError("Challenge deck has already been specified")
        }

        guard ChallengeDeckID.availableCases.contains(challengeDeckID) else {
            throw GameError("Invalid challenge deck choice")
        }

        events.append(
            .specifiedChallengeDeck(
                coachID: coinFlipWinnerCoachID,
                challengeDeckID: challengeDeckID
            )
        )

        config.challengeDeckID = challengeDeckID

        return Prompt(
            coachID: coinFlipWinnerCoachID,
            payload: .specifyRookieBonusRecipient(
                rookieBonusRecipientIDs: RookieBonusRecipientID.availableCases
            )
        )
    }
}
