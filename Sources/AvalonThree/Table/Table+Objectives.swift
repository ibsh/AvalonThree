//
//  Table+Objectives.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

public struct Objectives: Codable, Sendable {
    var first: ChallengeCard?
    var second: ChallengeCard?
    var third: ChallengeCard?
}

public enum ObjectiveID: String, Codable, Sendable {
    case first
    case second
    case third
}

extension Objectives {

    func getObjective(id: ObjectiveID) -> ChallengeCard? {
        switch id {
        case .first: first
        case .second: second
        case .third: third
        }
    }

    mutating func deal(from deck: inout [ChallengeCard]) -> [ObjectiveID] {
        var response = [ObjectiveID]()
        if first == nil, let card = deck.popFirst() {
            first = card
            response.append(.first)
        }
        if second == nil, let card = deck.popFirst() {
            second = card
            response.append(.second)
        }
        if third == nil, let card = deck.popFirst() {
            third = card
            response.append(.third)
        }
        return response
    }

    mutating func remove(_ id: ObjectiveID) {
        switch id {
        case .first: first = nil
        case .second: second = nil
        case .third: third = nil
        }
    }

    private var identified: [(ObjectiveID, ChallengeCard?)] {
        [
            (.first, first),
            (.second, second),
            (.third, third),
        ]
    }

    var notEmpty: [(ObjectiveID, ChallengeCard)] {
        identified.compactMap {
            guard let card = $0.1 else { return nil }
            return ($0.0, card)
        }
    }

    var emptyCount: Int {
        identified.count - notEmpty.count
    }
}
