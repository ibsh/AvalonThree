//
//  CoachIDRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

protocol CoachIDRandomizing: Sendable {
    func flipForCoachID() -> CoachID
}

struct DefaultCoachIDRandomizer: CoachIDRandomizing {
    func flipForCoachID() -> CoachID {
        guard let coachID = CoachID.allCases.randomElement() else {
            fatalError("No CoachID cases")
        }
        return coachID
    }
}
