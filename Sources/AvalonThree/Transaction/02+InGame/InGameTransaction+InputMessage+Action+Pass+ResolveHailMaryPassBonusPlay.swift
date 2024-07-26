//
//  InGameTransaction+InputMessage+Action+Pass+ResolveHailMaryPassBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionUseHailMaryPassBonusPlay() throws -> Prompt? {
        return try passActionResolveHailMaryPassBonusPlay(use: true)
    }

    mutating func passActionDeclineHailMaryPassBonusPlay() throws -> Prompt? {
        return try passActionResolveHailMaryPassBonusPlay(use: false)
    }

    private mutating func passActionResolveHailMaryPassBonusPlay(
        use: Bool
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            var validTargets = actionContext.history.lastResult(
                { entry -> Set<PassTarget>? in
                    guard case .passValidTargets(
                        let validTargets
                    ) = entry else {
                        return nil
                    }
                    return validTargets
                }
            )
        else {
            throw GameError("No action in history")
        }

        let bonusPlay = BonusPlay.hailMaryPass

        if use {
            try useBonusPlay(bonusPlay: bonusPlay, coachID: actionContext.coachID)

            // refresh valid targets now that the player has the bonus active

            validTargets = try getValidPassTargets(
                playerID: actionContext.playerID,
                hailMaryPass: true
            )

            history.append(.passValidTargets(validTargets))
        }

        return Prompt(
            coachID: actionContext.coachID,
            payload: .passActionSpecifyTarget(
                playerID: actionContext.playerID,
                validTargets: validTargets
            )
        )
    }
}
