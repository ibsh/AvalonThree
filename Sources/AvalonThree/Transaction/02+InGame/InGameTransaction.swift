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
    let previousPrompt: Prompt
    let randomizers: Randomizers

    var events = [Event]()

    init(
        table: Table,
        history: [HistoryEntry],
        previousPrompt: Prompt,
        randomizers: Randomizers
    ) {
        self.table = table
        self.history = history
        self.previousPrompt = previousPrompt
        self.randomizers = randomizers
    }
}
