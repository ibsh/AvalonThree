//
//  ConfigTransaction+InputMessage+Begin.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation

extension ConfigTransaction {

    mutating func beginGame() throws -> AddressedPrompt? {

        guard config.coinFlipWinnerCoachID == nil else {
            throw GameError("Game has already begun")
        }

        let coinFlipWinnerCoachID = randomizers.coachID.flipForCoachID()
        events.append(.flippedCoin(coachID: coinFlipWinnerCoachID))

        config.coinFlipWinnerCoachID = coinFlipWinnerCoachID

        return AddressedPrompt(
            coachID: coinFlipWinnerCoachID,
            prompt: .selectBoardSpec(boardSpecIDs: BoardSpecID.availableCases)
        )
    }
}
