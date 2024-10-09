//
//  InGameTransaction+InputMessage+Action+Block+ResolveAbsoluteCarnageBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseAbsoluteCarnageBonusPlay() throws -> AddressedPrompt? {
        return try blockActionResolveAbsoluteCarnageBonusPlay(use: true)
    }

    mutating func blockActionDeclineAbsoluteCarnageBonusPlay() throws -> AddressedPrompt? {
        return try blockActionResolveAbsoluteCarnageBonusPlay(use: false)
    }

    private mutating func blockActionResolveAbsoluteCarnageBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        let coachID = try history.latestTurnContext().coachID

        let bonusPlay = BonusPlay.absoluteCarnage

        if use {
            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)
        }

        return try blockActionRollForArmour()
    }
}
