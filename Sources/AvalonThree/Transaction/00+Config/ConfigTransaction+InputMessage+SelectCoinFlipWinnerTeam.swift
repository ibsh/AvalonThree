//
//  ConfigTransaction+InputMessage+SelectCoinFlipWinnerTeam.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func selectCoinFlipWinnerTeam(
        teamID: TeamID
    ) throws -> AddressedPrompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Coin has not been flipped yet")
        }

        guard config.rookieBonusRecipientID != nil else {
            throw GameError("Raw Talent bonus play recipient has not been specified yet")
        }

        guard config.coinFlipWinnerTeamID == nil else {
            throw GameError("Coin flip winner team has already been specified")
        }

        guard TeamID.availableCases.contains(teamID) else {
            throw GameError("Invalid coin flip winner team choice")
        }

        events.append(
            .specifiedTeam(coachID: coinFlipWinnerCoachID, teamID: teamID)
        )

        config.coinFlipWinnerTeamID = teamID

        return AddressedPrompt(
            coachID: coinFlipWinnerCoachID.inverse,
            prompt: .selectCoinFlipLoserTeam(
                teamIDs: TeamID.availableCases
            )
        )
    }
}
