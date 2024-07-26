//
//  Array+ToSet.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Foundation

extension RandomAccessCollection where Element: Hashable {

    func toSet() -> Set<Element> {
        Set(self)
    }
}
