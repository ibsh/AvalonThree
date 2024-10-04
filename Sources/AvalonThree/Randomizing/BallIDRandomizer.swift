//
//  BallIDRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation

public protocol BallIDRandomizing {
    func generate() -> Int
}

public final class DefaultBallIDRandomizer {

    private var nextValue = 1

    public init() { }
}

extension DefaultBallIDRandomizer: BallIDRandomizing {
    public func generate() -> Int {
        let result = nextValue
        nextValue += 1
        return result
    }
}
