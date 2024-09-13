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
                playerConfigs: table.config.coinFlipLoserTeamID.spec.playerConfigs(
                    coachID: table.coinFlipLoserCoachID
                )
            )
        )
    }
}
