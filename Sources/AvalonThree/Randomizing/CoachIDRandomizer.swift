//
//  CoachIDRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

public protocol CoachIDRandomizing {
    func flipForCoachID() -> CoachID
}

public final class DefaultCoachIDRandomizer {
    public init() { }
}

extension DefaultCoachIDRandomizer: CoachIDRandomizing {

    public func flipForCoachID() -> CoachID {
        guard let coachID = CoachID.allCases.randomElement() else {
            fatalError("No CoachID cases")
        }
        return coachID
    }
}
