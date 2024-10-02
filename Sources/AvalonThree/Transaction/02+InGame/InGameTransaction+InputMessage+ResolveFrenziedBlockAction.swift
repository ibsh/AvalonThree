//
//  InGameTransaction+InputMessage+ResolveFrenziedBlockAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useFrenziedSkillBlockAction() throws -> Prompt? {
        return try resolveFrenziedSkillBlockAction(useFreeAction: true)
    }

    mutating func declineFrenziedSkillBlockAction() throws -> Prompt? {
        return try resolveFrenziedSkillBlockAction(useFreeAction: false)
    }

    private mutating func resolveFrenziedSkillBlockAction(
        useFreeAction: Bool
    ) throws -> Prompt? {

        guard
            let playerID =
                try history
                .latestTurnContext().history.lastResult(
                    { entry -> PlayerID? in
                        guard
                            case .eligibleForFrenziedSkillBlockAction(let playerID) = entry
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

            guard let playerSquare = table.getPlayer(id: playerID)?.square else {
                throw GameError("Player is in reserves")
            }

            events.append(
                .declinedFrenziedSkillBlockAction(playerID: playerID, in: playerSquare)
            )
            return try endAction()
        }
    }
}
