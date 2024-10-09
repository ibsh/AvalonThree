//
//  InGameTransaction+InputMessage+Action+Block+ResolveProBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseProBonusPlay() throws -> AddressedPrompt? {
        return try blockActionResolveProBonusPlay(use: true)
    }

    mutating func blockActionDeclineProBonusPlay() throws -> AddressedPrompt? {
        return try blockActionResolveProBonusPlay(use: false)
    }

    private mutating func blockActionResolveProBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        let coachID = try history.latestTurnContext().coachID.inverse

        if use {
            _ = try useBonusPlay(bonusPlay: .pro, coachID: coachID)
        }

        return try blockActionRollForArmour()
    }
}
