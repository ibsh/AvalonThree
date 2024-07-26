//
//  D6Randomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

protocol D6Randomizing: DXRandomizing { }

struct DefaultD6Randomizer: D6Randomizing {

    func roll() -> Int {
        guard let result = range.randomElement() else {
            fatalError("No sides on my D6")
        }
        return result
    }

    var range: ClosedRange<Int> {
        TableConstants.d6Range
    }

    var die: Die {
        .d6
    }
}
