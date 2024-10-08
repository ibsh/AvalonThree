//
//  InGameTransaction+InputMessage+ResolveDefensivePlayBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func useDefensivePlayBonusPlay() throws -> AddressedPrompt? {
        return try resolveDefensivePlayBonusPlay(use: true)
    }

    mutating func declineDefensivePlayBonusPlay() throws -> AddressedPrompt? {
        return try resolveDefensivePlayBonusPlay(use: false)
    }

    private mutating func resolveDefensivePlayBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        let bonusPlay = BonusPlay.defensivePlay

        if use {
            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: turnContext.coachID)
        }

        return try beginTurn()
    }
}
