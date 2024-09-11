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

    let randomizers: Randomizers
    let uuidProvider: UUIDProviding

    init(
        phase: Phase,
        previousPrompt: Prompt?,
        randomizers: Randomizers,
        uuidProvider: UUIDProviding
    ) {
        self.phase = phase
        self.previousPrompt = previousPrompt
        self.randomizers = randomizers
        self.uuidProvider = uuidProvider
    }

    public init() {
        self.init(
            phase: .config(Config()),
            previousPrompt: nil,
            randomizers: Randomizers(),
            uuidProvider: DefaultUUIDProvider()
        )
    }
}
