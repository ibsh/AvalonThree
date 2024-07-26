//
//  Array+RemoveFirst.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/4/24.
//

import Foundation

extension Array {

    mutating func removeFirst(
        where shouldBeRemoved: (Element) throws -> Bool
    ) rethrows -> Element? {
        guard let index = try firstIndex(where: shouldBeRemoved) else { return nil }
        return remove(at: index)
    }
}
