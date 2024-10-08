//
//  Game.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public struct Game: Sendable {

    var phase: Phase
    var previousAddressedPrompt: AddressedPrompt?

    init(
        phase: Phase,
        previousAddressedPrompt: AddressedPrompt?
    ) {
        self.phase = phase
        self.previousAddressedPrompt = previousAddressedPrompt
    }

    public init() {
        self.init(
            phase: .config(Config()),
            previousAddressedPrompt: nil
        )
    }
}
