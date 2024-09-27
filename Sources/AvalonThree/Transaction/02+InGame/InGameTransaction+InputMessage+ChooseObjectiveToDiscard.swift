//
//  InGameTransaction+InputMessage+ChooseObjectiveToDiscard.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Foundation

extension InGameTransaction {

    mutating func selectObjectiveToDiscard(
        objectiveID: ObjectiveID
    ) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()
        guard
            let entry = turnContext.history.last,
            case .choosingObjectiveToDiscard(let objectiveIDs) = entry
        else {
            throw GameError("No discard prompt in history")
        }

        guard objectiveIDs.contains(objectiveID) else {
            throw GameError("Invalid objective ID")
        }

        guard let objective = table.objectives.getObjective(id: objectiveID) else {
            throw GameError("No objective")
        }

        history.append(
            .discardedObjective(objectiveID: objectiveID)
        )

        table.objectives.remove(objectiveID)
        table.discards.append(objective)
        events.append(
            .discardedObjective(
                coachID: turnContext.coachID,
                objectiveID: objectiveID,
                objective: objective
            )
        )
        events.append(
            .updatedDiscards(top: table.discards.last?.bonusPlay, count: table.discards.count)
        )

        return try beginTurn()
    }
}
