//
//  InGameTransaction+InputMessage+Action+HurlTeammate+ResolveAccuratePassBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func hurlTeammateActionUseAccuratePassBonusPlay() throws -> AddressedPrompt? {
        return try hurlTeammateActionResolvedAccuratePassBonusPlay(use: true)
    }

    mutating func hurlTeammateActionDeclineAccuratePassBonusPlay() throws -> AddressedPrompt? {
        return try hurlTeammateActionResolvedAccuratePassBonusPlay(use: false)
    }

    private mutating func hurlTeammateActionResolvedAccuratePassBonusPlay(
        use: Bool
    ) throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.accuratePass

        // update the action
        if use {
            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: actionContext.coachID)
        }
        return try hurlTeammateActionRollDie()
    }
}
