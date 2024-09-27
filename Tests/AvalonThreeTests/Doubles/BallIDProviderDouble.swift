//
//  BallIDProviderDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation
@testable import AvalonThree

final class BallIDProviderDouble: BallIDProviding {

    var nextResults: [Int] = []

    func generate() -> Int {
        nextResults.popFirst() ?? 123
    }
}
