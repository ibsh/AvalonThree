//
//  File.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 10/13/24.
//

import Foundation

extension Array {

    func distinct() -> Self where Element : Hashable {
        var result = Self()
        var set = Set<Element>()
        for element in self {
            if set.insert(element).inserted {
                result.append(element)
            }
        }
        return result
    }
}
