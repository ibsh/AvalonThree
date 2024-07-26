//
//  InGameTransaction+InputMessage+ResolveGetInThereBonusPlayReservesAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useGetInThereBonusPlayReservesAction() throws -> Prompt? {
        let turnContext = try history.latestTurnContext()

        guard
            let playerID = turnContext
                .historyEntriesSinceLastActionFinished
                .lastResult(
                    { entry -> PlayerID? in
                        guard case .eligibleForGetInThereBonusPlayReservesAction(
                            let playerID
                        ) = entry else {
                            return nil
                        }
                        return playerID
                    }
                )
        else {
            throw GameError("No player ID")
        }

        try useBonusPlay(bonusPlay: .getInThere, coachID: playerID.coachID)

        return try declareReservesAction(
            playerID: playerID,
            isFree: true
        )
    }

    mutating func declineGetInThereBonusPlayReservesAction() throws -> Prompt? {
        return try endAction()
    }
}
