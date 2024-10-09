//
//  InGameTransaction+InputMessage+Action+Block+ResolveBladedKnuckleDustersBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .bladedKnuckleDusters }

    mutating func blockActionUseBladedKnuckleDustersBonusPlay() throws -> AddressedPrompt? {
        _ = try useBonusPlay(
            bonusPlay: bonusPlay,
            coachID: try history.latestTurnContext().coachID
        )
        return try blockActionTargetPlayerInjured()
    }

    mutating func blockActionDeclineBladedKnuckleDustersBonusPlay() throws -> AddressedPrompt? {
        return try blockActionRollForArmour()
    }
}
