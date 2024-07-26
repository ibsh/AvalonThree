//
//  InGameTransaction+InputMessage+ResolveHeadbuttBlockAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useHeadbuttSkillBlockAction() throws -> Prompt? {
        return try resolveHeadbuttSkillBlockAction(useFreeAction: true)
    }

    mutating func declineHeadbuttSkillBlockAction() throws -> Prompt? {
        return try resolveHeadbuttSkillBlockAction(useFreeAction: false)
    }

    private mutating func resolveHeadbuttSkillBlockAction(
        useFreeAction: Bool
    ) throws -> Prompt? {

        guard
            let playerID =
                try history
                .latestTurnContext().history.lastResult(
                    { entry -> PlayerID? in
                        guard
                            case .eligibleForHeadbuttSkillBlockAction(let playerID) = entry
                        else { return nil }
                        return playerID
                    }
                )
        else {
            throw GameError("No player")
        }

        if useFreeAction {

            return try declareBlockAction(
                playerID: playerID,
                isFree: true
            )

        } else {

            events.append(
                .declinedHeadbuttSkillBlockAction(playerID: playerID)
            )
            return try endAction()
        }
    }
}
