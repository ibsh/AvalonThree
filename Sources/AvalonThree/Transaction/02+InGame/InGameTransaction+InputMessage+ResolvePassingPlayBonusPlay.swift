//
//  InGameTransaction+InputMessage+ResolvePassingPlayBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func usePassingPlayBonusPlay() throws -> AddressedPrompt? {
        return try resolvePassingPlayBonusPlay(use: true)
    }

    mutating func declinePassingPlayBonusPlay() throws -> AddressedPrompt? {
        return try resolvePassingPlayBonusPlay(use: false)
    }

    private mutating func resolvePassingPlayBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        let bonusPlay = BonusPlay.passingPlay

        if use {
            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: turnContext.coachID)
        }

        return try beginTurn()
    }
}
