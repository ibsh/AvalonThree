//
//  ConfigTransaction+InputMessage+SpecifyBoardSpec.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func specifyBoardSpec(
        boardSpecID: BoardSpecID
    ) throws -> Prompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Coin has not been flipped yet")
        }

        guard config.boardSpecID == nil else {
            throw GameError("Board spec has already been specified")
        }

        guard BoardSpecID.availableCases.contains(boardSpecID) else {
            throw GameError("Invalid board spec choice")
        }

        events.append(
            .specifiedBoardSpec(
                coachID: coinFlipWinnerCoachID,
                boardSpecID: boardSpecID,
                boardSpec: boardSpecID.spec
            )
        )

        config.boardSpecID = boardSpecID

        return Prompt(
            coachID: coinFlipWinnerCoachID,
            payload: .specifyChallengeDeck(
                challengeDeckIDs: ChallengeDeckID.availableCases
            )
        )
    }
}
