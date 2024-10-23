//
//  ConfigTransaction+InputMessage+SelectChallengeDeck.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func configureChallengeDeck(
        challengeDeckConfig: ChallengeDeckConfig
    ) throws -> AddressedPrompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Coin has not been flipped yet")
        }

        guard config.boardSpecID != nil else {
            throw GameError("Board spec has not been specified yet")
        }

        guard config.challengeDeckConfig == nil else {
            throw GameError("Challenge deck has already been configured")
        }

        events.append(
            .configuredChallengeDeck(
                coachID: coinFlipWinnerCoachID,
                challengeDeckConfig: challengeDeckConfig
            )
        )

        config.challengeDeckConfig = challengeDeckConfig

        return AddressedPrompt(
            coachID: coinFlipWinnerCoachID,
            prompt: .selectRookieBonusRecipient(
                rookieBonusRecipientIDs: RookieBonusRecipientID.availableCases
            )
        )
    }
}
