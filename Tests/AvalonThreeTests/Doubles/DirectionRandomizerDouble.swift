//
//  DirectionRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class DirectionRandomizerDouble: DirectionRandomizing {

    var nextResults: [Direction] = []

    func rollForDirection() -> Direction {
        nextResults.popFirst() ?? DefaultDirectionRandomizer().rollForDirection()
    }
}
