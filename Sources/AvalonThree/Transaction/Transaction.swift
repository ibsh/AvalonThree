//
//  Transaction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

protocol Transaction {

    mutating func processInputMessageWrapper(
        _ messageWrapper: InputMessageWrapper
    ) throws -> AddressedPrompt?

    var events: [Event] { get set }

    var randomizers: Randomizers { get }
}
