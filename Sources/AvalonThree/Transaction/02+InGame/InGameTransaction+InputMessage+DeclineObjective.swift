//
//  InGameTransaction+InputMessage+DeclineObjective.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/4/24.
//

import Foundation

extension InGameTransaction {

    mutating func declineToClaimObjective() throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let entry = turnContext.history.last,
            case .choosingObjectiveToClaim(let objectiveIDs) = entry
        else {
            throw GameError("No claim in history")
        }

        history.append(
            .declinedToClaimObjective
        )
        events.append(.declinedObjectives(coachID: turnContext.coachID, objectiveIDs: objectiveIDs))

        return try endAction()
    }
}
