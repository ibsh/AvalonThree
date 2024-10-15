//
//  InGameTransaction+InputMessage+ChooseObjectiveToDiscard.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Foundation

extension InGameTransaction {

    mutating func selectObjectiveToDiscard(
        objectiveIndex: Int
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()
        guard
            let entry = turnContext.history.last,
            case .choosingObjectiveToDiscard(let objectiveIndices) = entry
        else {
            throw GameError("No discard prompt in history")
        }

        guard objectiveIndices.contains(objectiveIndex) else {
            throw GameError("Invalid objective ID")
        }

        guard let objective = try table.objectives.getObjective(index: objectiveIndex) else {
            throw GameError("No objective")
        }

        history.append(
            .discardedObjective(objectiveIndex: objectiveIndex)
        )

        try table.objectives.remove(objectiveIndex)
        table.discards.append(objective)
        events.append(
            .discardedObjective(
                coachID: turnContext.coachID,
                objectiveIndex: objectiveIndex,
                objective: objective,
                objectives: table.objectives.toWrappedObjectives()
            )
        )
        events.append(
            .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
        )

        return try beginTurn()
    }
}
