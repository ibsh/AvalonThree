//
//  ConfigTransaction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/7/24.
//

import Foundation

struct ConfigTransaction: Transaction {

    var config: Config
    var events: [Event]
    let randomizers: Randomizers

    var table: Table?

    init(
        config: Config,
        randomizers: Randomizers
    ) {
        self.config = config
        self.randomizers = randomizers
        self.events = []
    }
}

extension ConfigTransaction {
    var coinFlipWinnerCoachID: CoachID? {
        config.coinFlipWinnerCoachID
    }

    var coinFlipLoserCoachID: CoachID? {
        coinFlipWinnerCoachID?.inverse
    }
}
