//
//  Sequence+CountWhere.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 8/19/24.
//

import Foundation

extension Sequence {

    func count(where condition: (Element) -> Bool) -> Int {
        self.lazy.filter(condition).count
    }
}
