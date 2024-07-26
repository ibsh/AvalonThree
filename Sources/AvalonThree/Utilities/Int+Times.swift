//
//  Int+Times.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension Int {

    func times(_ callback: (Int) -> Void) {
        if self > 0 {
            for i in 0..<self {
                callback(i)
            }
        }
    }

    func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (_ partialResult: Result) throws -> Result
    ) rethrows -> Result {
        guard self > 0 else { return initialResult }
        return try (0..<self).indices.reduce(initialResult) { partialResult, _ in
            try nextPartialResult(partialResult)
        }
    }
}
