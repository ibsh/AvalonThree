//
//  InGameTransaction+InputMessage+Action+Block+ResolveToughEnoughBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseToughEnoughBonusPlay() throws -> AddressedPrompt? {
        return try blockActionResolveToughEnoughBonusPlay(use: true)
    }

    mutating func blockActionDeclineToughEnoughBonusPlay() throws -> AddressedPrompt? {
        return try blockActionResolveToughEnoughBonusPlay(use: false)
    }

    private mutating func blockActionResolveToughEnoughBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        let coachID = try history.latestTurnContext().coachID.inverse

        let bonusPlay = BonusPlay.toughEnough

        if use {
            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)
        }

        return try blockActionRollForArmour()
    }
}
