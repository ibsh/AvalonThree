//
//  Game.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public struct Game: Sendable {

    var phase: Phase
    var previousPrompt: Prompt?

    init(
        phase: Phase,
        previousPrompt: Prompt?
    ) {
        self.phase = phase
        self.previousPrompt = previousPrompt
    }

    public init() {
        self.init(
            phase: .config(Config()),
            previousPrompt: nil
        )
    }
}
