//
//  InGameTransaction+InputMessage+Action+Block+ResolveAbsolutelyNailsBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseAbsolutelyNailsBonusPlay() throws -> Prompt? {
        return try blockActionResolveAbsolutelyNailsBonusPlay(use: true)
    }

    mutating func blockActionDeclineAbsolutelyNailsBonusPlay() throws -> Prompt? {
        return try blockActionResolveAbsolutelyNailsBonusPlay(use: false)
    }

    private mutating func blockActionResolveAbsolutelyNailsBonusPlay(
        use: Bool
    ) throws -> Prompt? {

        let coachID = try history.latestTurnContext().coachID.inverse

        let bonusPlay = BonusPlay.absolutelyNails

        if use {
            try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)
        }

        return try blockActionRollForArmour()
    }
}
