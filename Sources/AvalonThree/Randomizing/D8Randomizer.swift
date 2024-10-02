//
//  D8Randomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation

public protocol D8Randomizing: DXRandomizing { }

public final class DefaultD8Randomizer {
    public init() { }
}

extension DefaultD8Randomizer: D8Randomizing {

    public func roll() -> Int {
        guard let result = range.randomElement() else {
            fatalError("No sides on my D8")
        }
        return result
    }

    public var range: ClosedRange<Int> {
        TableConstants.d8Range
    }

    public var die: Die {
        .d8
    }
}
