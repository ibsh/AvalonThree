//
//  RandomAccessCollection+FindAndMap.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/6/24.
//

import Foundation

extension RandomAccessCollection {

    func lastResult<R>(_ mapper: (Element) -> R?) -> R? {
        guard let index = lastIndex(where: { mapper($0) != nil }) else { return nil }
        return mapper(self[index])
    }
}
