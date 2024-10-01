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

        let objectives = try objectiveIDs.reduce(
            [ObjectiveID: Challenge]()) { partialResult, objectiveID in
                guard let objective = table.objectives.getObjective(id: objectiveID) else {
                    throw GameError("No objective")
                }
                return partialResult.adding(
                    key: objectiveID,
                    value: objective.challenge
                )
            }

        history.append(
            .declinedToClaimObjective
        )
        events.append(
            .declinedObjectives(
                coachID: turnContext.coachID,
                objectives: objectives
            )
        )

        return try endAction()
    }
}
