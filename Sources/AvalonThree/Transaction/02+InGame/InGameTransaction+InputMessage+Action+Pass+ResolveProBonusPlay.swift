//
//  InGameTransaction+InputMessage+Action+Pass+ResolveProBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionUseProBonusPlay() throws -> AddressedPrompt? {
        return try passActionResolveProBonusPlay(use: true)
    }

    mutating func passActionDeclineProBonusPlay() throws -> AddressedPrompt? {
        return try passActionResolveProBonusPlay(use: false)
    }

    private mutating func passActionResolveProBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        if use {
            _ = try useBonusPlay(bonusPlay: .pro, coachID: actionContext.coachID)
        }
        return try passActionRollDie()
    }
}
