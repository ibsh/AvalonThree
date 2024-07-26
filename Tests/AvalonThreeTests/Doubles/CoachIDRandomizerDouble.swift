//
//  CoachIDRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class CoachIDRandomizerDouble: CoachIDRandomizing {

    var nextResult: CoachID?

    func flipForCoachID() -> CoachID {
        nextResult ?? DefaultCoachIDRandomizer().flipForCoachID()
    }
}
