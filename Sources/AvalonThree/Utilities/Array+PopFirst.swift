//
//  Array+PopFirst.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

extension Array {

    mutating func popFirst() -> Element? {
        var slice = self[self.indices]
        let result = slice.popFirst()
        self = Array(slice)
        return result
    }
}
