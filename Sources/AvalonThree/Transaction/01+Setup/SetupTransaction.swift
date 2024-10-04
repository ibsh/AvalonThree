//
//  SetupTransaction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/7/24.
//

import Foundation

struct SetupTransaction: Transaction {

    var table: Table
    var events: [Event]
    let randomizers: Randomizers

    init(
        table: Table,
        randomizers: Randomizers
    ) {
        self.table = table
        self.randomizers = randomizers
        self.events = []
    }
}

extension SetupTransaction {
    var coinFlipWinnerCoachID: CoachID? {
        table.coinFlipWinnerCoachID
    }

    var coinFlipLoserCoachID: CoachID? {
        coinFlipWinnerCoachID?.inverse
    }
}
