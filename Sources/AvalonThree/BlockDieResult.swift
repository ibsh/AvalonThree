//
//  BlockDieResult.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/16/24.
//

import Foundation

public enum BlockDieResult: Codable, Sendable {
    case miss
    case shove
    case tackle
    case smash
    case kerrunch
}
