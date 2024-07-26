//
//  InGameTransaction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

struct InGameTransaction: Transaction {

    var table: Table
    var history: [HistoryEntry]
    let previousPromptPayload: PromptPayload
    let randomizers: Randomizers
    let uuidProvider: UUIDProviding

    var events = [Event]()

    init(
        table: Table,
        history: [HistoryEntry],
        previousPromptPayload: PromptPayload,
        randomizers: Randomizers,
        uuidProvider: UUIDProviding
    ) {
        self.table = table
        self.history = history
        self.previousPromptPayload = previousPromptPayload
        self.randomizers = randomizers
        self.uuidProvider = uuidProvider
    }
}

extension InGameTransaction {
    var coinFlipWinnerCoachID: CoachID {
        table.coinFlipWinnerCoachID
    }

    var coinFlipLoserCoachID: CoachID {
        table.coinFlipLoserCoachID
    }
}
