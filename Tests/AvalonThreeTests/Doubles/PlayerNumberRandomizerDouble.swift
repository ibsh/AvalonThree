//
//  PlayerNumberRandomizerDouble.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/26/24.
//

import Foundation
@testable import AvalonThree

final class PlayerNumberRandomizerDouble: PlayerNumberRandomizing {

    var nextResults: [[Int]] = []

    func getPlayerNumbers(count: Int) -> [Int] {
        nextResults.popFirst() ?? DefaultPlayerNumberRandomizer().getPlayerNumbers(count: count)
    }
}
