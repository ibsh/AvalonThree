//
//  HistoryEntries.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/9/24.
//

import Foundation

extension RandomAccessCollection where Element == HistoryEntry {

    func latestTurnContext() throws -> TurnContext {
        guard
            let startIndex = lastIndex(
                where: { entry in
                    guard case .prepareForTurn = entry else { return false }
                    return true
                }
            )
        else {
            throw GameError("No turn yet")
        }

        let startEntry = self[startIndex]
        guard
            case .prepareForTurn(
                let coachID,
                let isSpecial,
                let mustDiscardObjective
            ) = startEntry
        else {
            throw GameError("No turn yet")
        }

        let nextIndex = self.index(after: startIndex)
        let history: any RandomAccessCollection<HistoryEntry> = {
            guard indices.contains(nextIndex) else { return [] }
            return self[nextIndex...]
        }()

        return TurnContext(
            coachID: coachID,
            isSpecial: isSpecial,
            mustDiscardObjective: mustDiscardObjective,
            history: history
        )
    }
}

struct TurnContext {
    let coachID: CoachID
    let isSpecial: SpecialTurn?
    let mustDiscardObjective: Bool
    let history: any RandomAccessCollection<HistoryEntry>

    var isFirst: Bool {
        switch isSpecial {
        case .none, .second, .final: false
        case .first: true
        }
    }

    var isFirstOrSecond: Bool {
        switch isSpecial {
        case .none, .final: false
        case .first, .second: true
        }
    }

    var isFinal: Bool {
        switch isSpecial {
        case .none, .first, .second: false
        case .final: true
        }
    }

    func actionContexts() throws -> [ActionContext] {
        try history.reduce([ActionContext]()) { partialResult, entry in
            switch entry {
            case .actionDeclaration(let declaration, let snapshot):
                if let previous = partialResult.last {
                    guard previous.history.contains(.actionFinished) else {
                        throw GameError("Unfinished action")
                    }
                }
                return partialResult + [
                    ActionContext(
                        declaration: declaration,
                        snapshot: snapshot,
                        history: []
                    )
                ]

            default:
                guard var actionContext = partialResult.last else {
                    return partialResult
                }
                var partialResult = partialResult
                actionContext.history.append(entry)
                partialResult[partialResult.indices.upperBound - 1] = actionContext
                return partialResult
            }
        }
    }

    var historyEntriesSinceLastActionFinished: [HistoryEntry] {
        history.reduce([HistoryEntry]()) { partialResult, entry in
            switch entry {
            case .actionFinished: []
            default: partialResult + [entry]
            }
        }
    }
}

struct ActionContext {
    let declaration: ActionDeclaration
    let snapshot: ActionSnapshot

    fileprivate(set) var history: [HistoryEntry]

    var playerID: PlayerID {
        declaration.playerID
    }

    var coachID: CoachID {
        declaration.coachID
    }

    var actionID: ActionID {
        declaration.actionID
    }

    var isFinished: Bool {
        history.contains(.actionFinished)
    }

    var isFree: Bool {
        history.contains(.actionIsFree)
    }

    var isCancelled: Bool {
        history.contains(.actionCancelled)
    }
}
