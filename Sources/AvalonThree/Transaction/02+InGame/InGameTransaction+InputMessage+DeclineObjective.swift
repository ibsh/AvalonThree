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
            case .choosingObjectiveToClaim(let objectiveIndices) = entry
        else {
            throw GameError("No claim in history")
        }

        let objectives = try objectiveIndices.reduce(
            [Int: Challenge]()) { partialResult, objectiveIndex in
                guard let objective = try table.objectives.getObjective(index: objectiveIndex) else {
                    throw GameError("No objective")
                }
                return partialResult.adding(
                    key: objectiveIndex,
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
