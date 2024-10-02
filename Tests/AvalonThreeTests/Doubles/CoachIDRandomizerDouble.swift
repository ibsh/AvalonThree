//
//  CoachIDRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

func coachID(_ nextResults: CoachID...) -> CoachIDRandomizing {
    CoachIDRandomizerDouble(nextResults)
}

private final class CoachIDRandomizerDouble: CoachIDRandomizing {

    private var nextResults: [CoachID]

    init(_ nextResults: [CoachID]) {
        self.nextResults = nextResults
    }

    func flipForCoachID() -> CoachID {
        nextResults.popFirst() ?? DefaultCoachIDRandomizer().flipForCoachID()
    }
}
