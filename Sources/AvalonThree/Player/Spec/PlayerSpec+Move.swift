//
//  PlayerSpec+Move.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Foundation

extension PlayerSpec {
    enum Move: Hashable, Codable, Sendable {
        case fixed(Int)
        case d6
    }
}
