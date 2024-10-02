//
//  D6Randomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

public protocol D6Randomizing: DXRandomizing { }

public final class DefaultD6Randomizer {
    public init() { }
}

extension DefaultD6Randomizer: D6Randomizing {

    public func roll() -> Int {
        guard let result = range.randomElement() else {
            fatalError("No sides on my D6")
        }
        return result
    }

    public var range: ClosedRange<Int> {
        TableConstants.d6Range
    }

    public var die: Die {
        .d6
    }
}
