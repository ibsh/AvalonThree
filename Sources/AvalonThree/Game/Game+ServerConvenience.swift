//
//  Game+ServerConvenience.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/13/24.
//

import Foundation

extension Game {

    private var table: Table? {
        switch phase {
        case .config:
            nil
        case .setup(let table),
             .active(let table, _),
             .finished(let table):
            table
        }
    }

    public func objective(id: ObjectiveID) -> ChallengeCard? {
        table?.objectives.getObjective(id: id)
    }

    public func objectiveIndex(id: ObjectiveID) -> Int {
        switch id {
        case .first: 0
        case .second: 1
        case .third: 2
        }
    }

    public var coinFlipWinnerCoachID: CoachID? {
        table?.coinFlipWinnerCoachID
    }

    public func playerIDInSquare(_ square: Square) -> PlayerID? {
        table?.playerInSquare(square)?.id
    }

    public func squareContainingBall(_ ballID: BallID) -> Square? {
        guard
            let table,
            let ball = table.getBall(id: ballID)
        else {
            return nil
        }
        switch ball.state {
        case .held(playerID: let playerID):
            return table.getPlayer(id: playerID)?.square
        case .loose(square: let square):
            return square
        }
    }

    public func visualDirection(from playerID: PlayerID, to targetSquare: Square) -> Direction? {
        guard
            let table,
            let player = table.getPlayer(id: playerID),
            let playerSquare = player.square
        else {
            return nil
        }
        return playerSquare.visualDirection(to: targetSquare)
    }

    public func visualDirection(from ballID: BallID, to targetSquare: Square) -> Direction? {
        squareContainingBall(ballID)?.visualDirection(to: targetSquare)
    }
}
