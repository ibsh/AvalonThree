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
        randomizers: Randomizers = Randomizers(),
        ballIDProvider: BallIDProviding = DefaultBallIDProvider()
    ) throws -> ([Event], Prompt?) {
        try validate(messageWrapper)
        return try process(
            messageWrapper: messageWrapper,
            priorEvents: [],
            randomizers: randomizers,
            ballIDProvider: ballIDProvider
        )
    }

    private mutating func process(
        messageWrapper: InputMessageWrapper,
        priorEvents: [Event],
        randomizers: Randomizers,
        ballIDProvider: BallIDProviding
    ) throws -> ([Event], Prompt?) {
        switch phase {
        case .config(let config):
            var transaction = ConfigTransaction(
                config: config,
                randomizers: randomizers
            )
            if let prompt = try transaction.processInputMessageWrapper(messageWrapper) {
                phase = .config(transaction.config)
                previousPrompt = prompt
                return (priorEvents + transaction.events, prompt)
            } else if let table = transaction.table {
                phase = .setup(table)
                return try process(
                    messageWrapper: messageWrapper,
                    priorEvents: priorEvents + transaction.events,
                    randomizers: randomizers,
                    ballIDProvider: ballIDProvider
                )
            } else {
                throw GameError("No prompt or table")
            }

        case .setup(let table):
            var transaction = SetupTransaction(
                table: table,
                randomizers: randomizers,
                ballIDProvider: ballIDProvider
            )
            if let prompt = try transaction.processInputMessageWrapper(messageWrapper) {
                phase = .setup(transaction.table)
                previousPrompt = prompt
                return (priorEvents + transaction.events, prompt)
            } else {
                phase = .active(transaction.table, [])
                return try process(
                    messageWrapper: messageWrapper,
                    priorEvents: priorEvents + transaction.events,
                    randomizers: randomizers,
                    ballIDProvider: ballIDProvider
                )
            }

        case .active(let table, let history):
            guard let previousPrompt else {
                throw GameError("No last prompt")
            }

            let history: [HistoryEntry] = {
                if let startIndex = history.lastIndex(
                    where: { entry in
                        guard case .prepareForTurn = entry else { return false }
                        return true
                    }
                ) {
                    return Array(history[startIndex...])
                }
                return []
            }()

            var transaction = InGameTransaction(
                table: table,
                history: history,
                previousPromptPayload: previousPrompt.payload,
                randomizers: randomizers,
                ballIDProvider: ballIDProvider
            )
            if let prompt = try transaction.processInputMessageWrapper(messageWrapper) {
                phase = .active(transaction.table, transaction.history)
                self.previousPrompt = prompt
                return (priorEvents + transaction.events, prompt)
            } else {
                phase = .finished(transaction.table)
                return try process(
                    messageWrapper: messageWrapper,
                    priorEvents: priorEvents + transaction.events,
                    randomizers: randomizers,
                    ballIDProvider: ballIDProvider
                )
            }

        case .finished:
            return (priorEvents, nil)
        }
    }
}
