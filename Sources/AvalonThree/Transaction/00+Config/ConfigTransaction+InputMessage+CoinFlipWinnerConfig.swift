//
//  ConfigTransaction+InputMessage+CoinFlipWinnerConfig.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func coinFlipWinnerConfig(
        coinFlipWinnerConfig: CoinFlipWinnerConfig
    ) throws -> Prompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Game has not begun yet")
        }

        guard config.coinFlipWinnerConfig == nil else {
            throw GameError("Second coach has already configured")
        }

        events.append(.coinFlipWinnerConfigured(config: coinFlipWinnerConfig))

        config.coinFlipWinnerConfig = coinFlipWinnerConfig

        return Prompt(
            coachID: coinFlipWinnerCoachID.inverse,
            payload: .coinFlipLoserConfig(
                teamIDs: TeamID.availableCases
            )
        )
    }
}
