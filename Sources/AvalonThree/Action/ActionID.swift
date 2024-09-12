//
//  ActionID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

public enum ActionID: String, CaseIterable, Codable, Sendable {
    case run
    case mark
    case pass
    case hurlTeammate
    case foul
    case block
    case sidestep
    case standUp
    case reserves
}

extension ActionID {
    func isEquivalentTo(_ other: ActionID) -> Bool {
        switch (self, other) {
        case (.run, .run),
             (.mark, .mark),
             (.pass, .pass),
             (.pass, .hurlTeammate),
             (.hurlTeammate, .hurlTeammate),
             (.hurlTeammate, .pass),
             (.foul, .foul),
             (.block, .block),
             (.sidestep, .sidestep),
             (.standUp, .standUp),
             (.reserves, .reserves):
            true
        default:
            false
        }
    }
}
