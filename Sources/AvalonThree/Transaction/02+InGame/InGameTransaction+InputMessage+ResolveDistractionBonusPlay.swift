//
//  InGameTransaction+InputMessage+ResolveDistractionBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func useDistractionBonusPlaySidestepAction(
        playerID: PlayerID
    ) throws -> Prompt? {
        return try resolveDistractionBonusPlaySidestepAction(
            use: playerID
        )
    }

    mutating func declineDistractionBonusPlaySidestepAction() throws -> Prompt? {
        return try resolveDistractionBonusPlaySidestepAction(
            use: nil
        )
    }

    private mutating func resolveDistractionBonusPlaySidestepAction(
        use: PlayerID?
    ) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()
        let coachID = turnContext.coachID.inverse

        guard
            let validPlayers = turnContext.history.lastResult(
                { entry -> Set<PlayerID>? in
                    guard
                        case .eligibleForDistractionBonusPlaySidestepAction(
                            let validPlayers
                        ) = entry
                    else { return nil }
                    return validPlayers
                }
            )
        else {
            throw GameError("No valid players")
        }

        let bonusPlay = BonusPlay.distraction

        if let playerID = use {
            guard validPlayers.contains(playerID) else {
                throw GameError("Invalid player")
            }

            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)

            return try declareSidestepAction(
                playerID: playerID,
                isFree: true
            )
        }

        return try endAction()
    }
}
