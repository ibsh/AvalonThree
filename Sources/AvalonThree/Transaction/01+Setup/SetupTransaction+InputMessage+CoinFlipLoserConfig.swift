//
//  SetupTransaction+InputMessage+CoinFlipLoserConfig.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension SetupTransaction {

    mutating func specifyCoinFlipLoserTeam() throws -> Prompt? {

        return Prompt(
            coachID: table.coinFlipLoserCoachID,
            payload: .arrangePlayers(
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
