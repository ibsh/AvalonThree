//
//  Game+Phase.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension Game {
    enum Phase: Sendable {
        case config(Config)
        case setup(Table)
        case active(Table, [HistoryEntry])
        case finished(Table)
    }
}
