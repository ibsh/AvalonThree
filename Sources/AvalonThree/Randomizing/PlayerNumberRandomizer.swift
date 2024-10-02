//
//  PlayerNumberRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/25/24.
//

import Foundation

public protocol PlayerNumberRandomizing {
    func generate() -> Int
}

public final class DefaultPlayerNumberRandomizer {
    public init() { }
}

extension DefaultPlayerNumberRandomizer: PlayerNumberRandomizing {

    public func generate() -> Int {
        guard let result = (0...99).randomElement() else {
            fatalError("No player numbers in my range")
        }
        return result
    }
}
