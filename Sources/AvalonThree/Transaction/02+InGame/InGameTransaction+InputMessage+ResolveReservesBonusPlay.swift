//
//  InGameTransaction+InputMessage+ResolveReservesBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useReservesBonusPlayReservesAction(playerID: PlayerID) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard
            playerID.coachID == turnContext.coachID,
            try playerCanDeclareAction(
                player: player,
                actionID: .reserves
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            throw GameError("Invalid player")
        }

        _ = try useBonusPlay(bonusPlay: .reserves, coachID: playerID.coachID)
        return try declareReservesAction(
            playerID: playerID,
            isFree: true
        )
    }

    mutating func declineReservesBonusPlayReservesAction() throws -> Prompt? {
        return try endAction()
    }
}
