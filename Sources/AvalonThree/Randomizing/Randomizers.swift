//
//  Randomizers.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation

struct Randomizers {
    let blockDie: BlockDieRandomizing
    let coachID: CoachIDRandomizing
    let d6: D6Randomizing
    let d8: D8Randomizing
    let deck: DeckRandomizing
    let direction: DirectionRandomizing
    let foulDie: FoulDieRandomizing
    let trapdoor: TrapdoorRandomizing

    init(
        blockDie: BlockDieRandomizing = DefaultBlockDieRandomizer(),
        coachID: CoachIDRandomizing = DefaultCoachIDRandomizer(),
        d6: D6Randomizing = DefaultD6Randomizer(),
        d8: D8Randomizing = DefaultD8Randomizer(),
        deck: DeckRandomizing = DefaultDeckRandomizer(),
        direction: DirectionRandomizing = DefaultDirectionRandomizer(),
        foulDie: FoulDieRandomizing = DefaultFoulDieRandomizer(),
        trapdoor: TrapdoorRandomizing = DefaultTrapdoorRandomizer()
    ) {
        self.blockDie = blockDie
        self.coachID = coachID
        self.d6 = d6
        self.d8 = d8
        self.deck = deck
        self.direction = direction
        self.foulDie = foulDie
        self.trapdoor = trapdoor
    }
}
