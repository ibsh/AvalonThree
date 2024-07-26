//
//  Game+Extensions.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation
@testable import AvalonThree

extension Game {

    var table: Table {
        switch phase {
        case .config:
            fatalError("No table")
        case .setup(let table),
             .active(let table, _),
             .finished(let table):
            return table
        }
    }
}
