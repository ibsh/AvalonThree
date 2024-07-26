//
//  InGameTransaction+InputMessage+Action+HurlTeammate+ResolveProBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func hurlTeammateActionUseProBonusPlay() throws -> Prompt? {
        return try hurlTeammateActionResolvedProBonusPlay(use: true)
    }

    mutating func hurlTeammateActionDeclineProBonusPlay() throws -> Prompt? {
        return try hurlTeammateActionResolvedProBonusPlay(use: false)
    }

    private mutating func hurlTeammateActionResolvedProBonusPlay(
        use: Bool
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished
        else {
            throw GameError("No action in history")
        }

        if use {
            try useBonusPlay(bonusPlay: .pro, coachID: actionContext.coachID)
        }
        return try hurlTeammateActionRollDie()
    }
}
