//
//  ConfigTransaction+InputMessage+Begin.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation

extension ConfigTransaction {

    mutating func beginGame() throws -> Prompt? {

        guard config.coinFlipWinnerCoachID == nil else {
            throw GameError("Game has already begun")
        }

        let coinFlipWinnerCoachID = randomizers.coachID.flipForCoachID()
        events.append(.flippedCoin(coachID: coinFlipWinnerCoachID))

        config.coinFlipWinnerCoachID = coinFlipWinnerCoachID

        return Prompt(
            coachID: coinFlipWinnerCoachID,
            payload: .specifyCoinFlipWinnerConfig(
                boardSpecIDs: BoardSpecID.availableCases,
                challengeDeckIDs: ChallengeDeckID.availableCases,
                teamIDs: TeamID.availableCases
            )
        )
    }
}
