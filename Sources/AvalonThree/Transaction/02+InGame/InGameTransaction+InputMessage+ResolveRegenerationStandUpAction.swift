//
//  InGameTransaction+InputMessage+ResolveRegenerationStandUpAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useRegenerationSkillStandUpAction() throws -> Prompt? {
        return try resolveRegenerationSkillStandUpAction(useFreeAction: true)
    }

    mutating func declineRegenerationSkillStandUpAction() throws -> Prompt? {
        return try resolveRegenerationSkillStandUpAction(useFreeAction: false)
    }

    private mutating func resolveRegenerationSkillStandUpAction(
        useFreeAction: Bool
    ) throws -> Prompt? {

        guard
            let playerID =
                try history
                .latestTurnContext().history.lastResult(
                    { entry -> PlayerID? in
                        guard
                            case .eligibleForRegenerationSkillStandUpAction(let playerID) = entry
                        else { return nil }
                        return playerID
                    }
                )
        else {
            throw GameError("No player")
        }

        if useFreeAction {

            return try declareStandUpAction(
                playerID: playerID,
                isFree: true
            )

        } else {

            guard let playerSquare = table.getPlayer(id: playerID)?.square else {
                throw GameError("Player is in reserves")
            }

            events.append(
                .declinedRegenerationSkillStandUpAction(playerID: playerID, playerSquare: playerSquare)
            )
            return try endAction()
        }
    }
}
