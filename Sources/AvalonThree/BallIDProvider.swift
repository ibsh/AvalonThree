//
//  BallIDProvider.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation

protocol BallIDProviding: Sendable {
    func generate() -> Int
}

final class DefaultBallIDProvider: BallIDProviding {

    private var nextValue = 1

    func generate() -> Int {
        let result = nextValue
        nextValue += 1
        return result
    }
}
