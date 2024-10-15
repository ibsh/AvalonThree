//
//  InGameTransaction+InputMessage+DeclineObjective.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/4/24.
//

import Foundation

extension InGameTransaction {

    mutating func declineToClaimObjective() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let entry = turnContext.history.last,
            case .choosingObjectiveToClaim(let objectiveIndices) = entry
        else {
            throw GameError("No claim in history")
        }

        events.append(
            .declinedObjectives(
                coachID: turnContext.coachID,
                indices: objectiveIndices,
                objectives: table.objectives.toWrappedObjectives()
            )
        )

        return try endAction()
    }
}
