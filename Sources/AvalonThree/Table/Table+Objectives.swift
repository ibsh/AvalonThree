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

    mutating func remove(_ id: ObjectiveID) {
        switch id {
        case .first: first = nil
        case .second: second = nil
        case .third: third = nil
        }
    }

    var notEmpty: [ObjectiveID: ChallengeCard] {
        var result = [ObjectiveID: ChallengeCard]()
        if let first {
            result[.first] = first
        }
        if let second {
            result[.second] = second
        }
        if let third {
            result[.third] = third
        }
        return result
    }

    var emptyCount: Int {
        3 - notEmpty.count
    }
}
