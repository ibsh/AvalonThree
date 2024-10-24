//
//  ConfigTransaction+InputMessage+SelectRookieBonusRecipient.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func selectRookieBonusRecipient(
        rookieBonusRecipientID: RookieBonusRecipientID
    ) throws -> AddressedPrompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Coin has not been flipped yet")
        }

        guard config.challengeDeckConfig != nil else {
            throw GameError("Challenge deck has not been configured yet")
        }

        guard config.rookieBonusRecipientID == nil else {
            throw GameError("Raw Talent bonus play recipient has already been specified")
        }

        guard RookieBonusRecipientID.availableCases.contains(rookieBonusRecipientID) else {
            throw GameError("Invalid Raw Talent bonus play recipient choice")
        }

        events.append(
            .specifiedRookieBonusRecipient(
                coachID: coinFlipWinnerCoachID,
                recipientCoachID: {
                    switch rookieBonusRecipientID {
                    case (.noOne): nil
                    case (.coinFlipWinner): coinFlipWinnerCoachID
                    case (.coinFlipLoser): coinFlipWinnerCoachID.inverse
                    }
                }()
            )
        )

        config.rookieBonusRecipientID = rookieBonusRecipientID

        return AddressedPrompt(
            coachID: coinFlipWinnerCoachID,
            prompt: .selectTeam(
                teamIDs: TeamID.availableCases
            )
        )
    }
}
