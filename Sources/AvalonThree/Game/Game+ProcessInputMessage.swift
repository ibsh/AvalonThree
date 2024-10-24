//
//  Game+ProcessInputMessage.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension Game {

    public mutating func process(
        _ messageWrapper: InputMessageWrapper,
        randomizers: Randomizers = Randomizers()
    ) throws -> ([Event], AddressedPrompt?) {
        try validate(messageWrapper)
        return try process(
            messageWrapper: messageWrapper,
            priorEvents: [],
            randomizers: randomizers
        )
    }

    private mutating func process(
        messageWrapper: InputMessageWrapper,
        priorEvents: [Event],
        randomizers: Randomizers
    ) throws -> ([Event], AddressedPrompt?) {
        switch phase {
        case .config(let config):
            var transaction = ConfigTransaction(
                config: config,
                randomizers: randomizers
            )
            if let addressedPrompt = try transaction.processInputMessageWrapper(messageWrapper) {
                phase = .config(transaction.config)
                previousAddressedPrompt = addressedPrompt
                return (priorEvents + transaction.events, addressedPrompt)
            } else if let table = transaction.table {
                phase = .setup(table)
                return try process(
                    messageWrapper: messageWrapper,
                    priorEvents: priorEvents + transaction.events,
                    randomizers: randomizers
                )
            } else {
                throw GameError("No prompt or table")
            }

        case .setup(let table):
            var transaction = SetupTransaction(
                table: table,
                randomizers: randomizers
            )
            if let addressedPrompt = try transaction.processInputMessageWrapper(messageWrapper) {
                phase = .setup(transaction.table)
                previousAddressedPrompt = addressedPrompt
                return (priorEvents + transaction.events, addressedPrompt)
            } else {
                phase = .active(transaction.table, [])
                return try process(
                    messageWrapper: messageWrapper,
                    priorEvents: priorEvents + transaction.events,
                    randomizers: randomizers
                )
            }

        case .active(let table, let entireHistory):
            guard let previousAddressedPrompt else {
                throw GameError("No last prompt")
            }

            let (oldHistory, currentHistory): ([HistoryEntry], [HistoryEntry]) = {
                if let startIndex = entireHistory.lastIndex(
                    where: { entry in
                        guard case .prepareForTurn = entry else { return false }
                        return true
                    }
                ) {
                    return (
                        Array(entireHistory[..<startIndex]),
                        Array(entireHistory[startIndex...])
                    )
                }
                return (entireHistory, [])
            }()

            var transaction = InGameTransaction(
                table: table,
                history: currentHistory,
                previousPrompt: previousAddressedPrompt.prompt,
                randomizers: randomizers
            )

            guard
                let addressedPrompt = try transaction.processInputMessageWrapper(messageWrapper)
            else {
                phase = .finished(transaction.table)
                return try process(
                    messageWrapper: messageWrapper,
                    priorEvents: priorEvents + transaction.events,
                    randomizers: randomizers
                )
            }

            phase = .active(transaction.table, oldHistory + transaction.history)
            self.previousAddressedPrompt = addressedPrompt
            return (priorEvents + transaction.events, addressedPrompt)

        case .finished:
            return (priorEvents, nil)
        }
    }
}
