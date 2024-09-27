//
//  SetupTransaction+InputMessage+ArrangePlayers.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension SetupTransaction {

    mutating func arrangePlayers(
        playerPositions: [Square],
        coachID: CoachID
    ) throws -> Prompt? {

        guard let coinFlipLoserCoachID else {
            throw GameError("No coin flip")
        }

        if coachID == coinFlipLoserCoachID {
            return try coinFlipLoserArrangedPlayers(playerPositions: playerPositions)
        } else {
            return try coinFlipWinnerArrangedPlayers(playerPositions: playerPositions)
        }
    }

    private mutating func coinFlipLoserArrangedPlayers(
        playerPositions: [Square]
    ) throws -> Prompt? {

        guard let coinFlipLoserCoachID else {
            throw GameError("No coin flip")
        }

        guard playerPositions.count == table.coinFlipLoserTeamID.spec.playerSpecIDs.count else {
            throw GameError("Invalid player position count")
        }

        guard Set(playerPositions).count == playerPositions.count else {
            throw GameError("Non-unique positions")
        }

        guard table.players(coachID: coinFlipLoserCoachID).allSatisfy({ $0.isInReserves }) else {
            throw GameError("First coach already has players out of reserves")
        }

        guard playerPositions.allSatisfy({ table.squareIsUnobstructed($0) }) else {
            throw GameError("Position(s) are obstructed")
        }

        guard playerPositions.allSatisfy({ table.squareIsEmptyOfPlayers($0) }) else {
            throw GameError("Position(s) are not empty")
        }

        try playerPositions.enumerated().forEach { playerIndex, square in
            try playerStartsInSquare(
                playerID: PlayerID(coachID: coinFlipLoserCoachID, index: playerIndex),
                square: square
            )
        }

        let coinFlipWinnerCoachID = coinFlipLoserCoachID.inverse
        return Prompt(
            coachID: coinFlipWinnerCoachID,
            payload: .arrangePlayers(
                playerIDs: table
                    .coinFlipWinnerTeamID
                    .spec
                    .playerSetups(coachID: coinFlipWinnerCoachID)
                    .map { $0.id }
                    .toSet(),
                validSquares: Square
                    .endZoneSquares(coachID: coinFlipWinnerCoachID)
                    .toSet()
            )
        )
    }

    private mutating func coinFlipWinnerArrangedPlayers(
        playerPositions: [Square]
    ) throws -> Prompt? {

        guard let coinFlipWinnerCoachID else {
            throw GameError("No coin flip")
        }

        guard playerPositions.count == table.coinFlipWinnerTeamID.spec.playerSpecIDs.count else {
            throw GameError("Invalid player position count")
        }

        guard Set(playerPositions).count == playerPositions.count else {
            throw GameError("Non-unique positions")
        }

        guard
            table.players(
                coachID: coinFlipWinnerCoachID.inverse
            ).allSatisfy({ !$0.isInReserves })
        else {
            throw GameError("First coach still has players in reserves")
        }

        guard
            table.players(
                coachID: coinFlipWinnerCoachID
            ).allSatisfy({ $0.isInReserves })
        else {
            throw GameError("Second coach already has players out of reserves")
        }

        guard playerPositions.allSatisfy({ table.squareIsUnobstructed($0) }) else {
            throw GameError("Position(s) are obstructed")
        }

        guard playerPositions.allSatisfy({ table.squareIsEmptyOfPlayers($0) }) else {
            throw GameError("Position(s) are not empty")
        }

        try playerPositions.enumerated().forEach { playerIndex, square in
            try playerStartsInSquare(
                playerID: PlayerID(coachID: coinFlipWinnerCoachID, index: playerIndex),
                square: square
            )
        }

        return nil
    }
}
