//
//  InGameTransaction+InputMessage+Action+Pass+ResolveAccuratePassBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionUseAccuratePassBonusPlay() throws -> Prompt? {
        return try passActionResolveAccuratePassBonusPlay(use: true)
    }

    mutating func passActionDeclineAccuratePassBonusPlay() throws -> Prompt? {
        return try passActionResolveAccuratePassBonusPlay(use: false)
    }

    private mutating func passActionResolveAccuratePassBonusPlay(
        use: Bool
    ) throws -> Prompt? {

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
        return try passActionRollDie()
    }
}
