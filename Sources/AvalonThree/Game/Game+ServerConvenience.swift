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
}
