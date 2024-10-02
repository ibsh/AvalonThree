//
//  BallIDProvider.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation

public protocol BallIDProviding {
    func generate() -> Int
}

public final class DefaultBallIDProvider {

    private var nextValue = 1

    public init() { }
}

extension DefaultBallIDProvider: BallIDProviding {
    public func generate() -> Int {
        let result = nextValue
        nextValue += 1
        return result
    }
}
