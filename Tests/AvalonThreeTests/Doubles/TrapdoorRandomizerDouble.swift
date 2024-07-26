//
//  TrapdoorRandomizerDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
@testable import AvalonThree

final class TrapdoorRandomizerDouble: TrapdoorRandomizing {

    var nextResults: [Square] = []

    func selectRandomTrapdoor(from squares: Set<Square>) -> Square {
        nextResults.popFirst() ?? DefaultTrapdoorRandomizer().selectRandomTrapdoor(from: squares)
    }
}
