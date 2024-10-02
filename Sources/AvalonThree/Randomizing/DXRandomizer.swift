//
//  DXRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/18/24.
//

import Foundation

public protocol DXRandomizing {
    func roll() -> Int
    var range: ClosedRange<Int> { get }
    var die: Die { get }
}
