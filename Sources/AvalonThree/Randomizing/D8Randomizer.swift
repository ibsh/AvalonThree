//
//  D8Randomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation

protocol D8Randomizing: DXRandomizing { }

struct DefaultD8Randomizer: D8Randomizing {

    func roll() -> Int {
        guard let result = range.randomElement() else {
            fatalError("No sides on my D8")
        }
        return result
    }

    var range: ClosedRange<Int> {
        TableConstants.d8Range
    }

    var die: Die {
        .d8
    }
}
