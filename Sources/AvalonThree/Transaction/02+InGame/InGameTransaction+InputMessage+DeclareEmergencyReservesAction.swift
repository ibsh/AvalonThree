//
//  InGameTransaction+InputMessage+DeclareEmergencyReservesAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareEmergencyReservesAction(
        playerID: PlayerID
    ) throws -> Prompt? {

        guard
            try !history.latestTurnContext().actionContexts().contains(
                where: { !$0.isFinished }
            )
        else {
            throw GameError("Unfinished actions")
        }

        return try declareReservesAction(
            playerID: playerID,
            isFree: true
        )
    }
}
