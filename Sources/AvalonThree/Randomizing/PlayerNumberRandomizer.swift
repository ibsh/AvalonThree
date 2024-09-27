//
//  PlayerNumberRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/25/24.
//

import Foundation

protocol PlayerNumberRandomizing: Sendable {
    func getPlayerNumbers(count: Int) -> [Int]
}

struct DefaultPlayerNumberRandomizer: PlayerNumberRandomizing {

    func getPlayerNumbers(count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            guard let result = (0...99).randomElement() else {
                fatalError("No player numbers in my range")
            }
            set.insert(result)
        }
        return set.shuffled()
    }
}
