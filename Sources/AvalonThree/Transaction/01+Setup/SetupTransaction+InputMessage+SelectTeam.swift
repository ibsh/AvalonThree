//
//  SetupTransaction+InputMessage+SelectTeam.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension SetupTransaction {

    mutating func selectTeam() throws -> AddressedPrompt? {

        return AddressedPrompt(
            coachID: table.coinFlipLoserCoachID,
            prompt: .arrangePlayers(
                playerIDs: table
                    .config
                    .coinFlipLoserTeamID
                    .spec
                    .playerSetups(
                        coachID: table.coinFlipLoserCoachID
                    )
                    .map { $0.id }
                    .toSet(),
                validSquares: Square
                    .endZoneSquares(coachID: table.coinFlipLoserCoachID)
                    .toSet()
            )
        )
    }
}
