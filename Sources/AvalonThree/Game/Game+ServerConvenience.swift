//
//  Game+ServerConvenience.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/13/24.
//

import Foundation

extension Game {

    public var coinFlipWinnerCoachID: CoachID? {
        switch phase {
        case .config(let config):
            config.coinFlipWinnerCoachID
        case .setup(let table),
             .active(let table, _),
             .finished(let table):
            table.coinFlipWinnerCoachID
        }
    }

    public func playerIDInSquare(_ square: Square) -> PlayerID? {
        switch phase {
        case .config:
            nil
        case .setup(let table),
             .active(let table, _),
             .finished(let table):
            table.playerInSquare(square)?.id
        }
    }

    public func visualDirection(from playerID: PlayerID, to targetSquare: Square) -> Direction? {
        switch phase {
        case .config:
            return nil
        case .setup(let table),
             .active(let table, _),
             .finished(let table):
            guard
                let player = table.getPlayer(id: playerID),
                let playerSquare = player.square
            else {
                return nil
            }
            return playerSquare.visualDirection(to: targetSquare)
        }
    }
}
