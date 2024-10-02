//
//  InGameTransaction+InputMessage+ResolveCatchersInstinctsRunAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useCatchersInstinctsSkillRunAction() throws -> Prompt? {
        return try resolveCatchersInstinctsSkillRunAction(useFreeAction: true)
    }

    mutating func declineCatchersInstinctsSkillRunAction() throws -> Prompt? {
        return try resolveCatchersInstinctsSkillRunAction(useFreeAction: false)
    }

    private mutating func resolveCatchersInstinctsSkillRunAction(
        useFreeAction: Bool
    ) throws -> Prompt? {

        guard
            let targetPlayerID = try history.latestTurnContext().history.lastResult(
                { entry -> PlayerID? in
                    guard
                        case .eligibleForCatchersInstinctsSkillRunAction(let targetPlayerID) = entry
                    else { return nil }
                    return targetPlayerID
                }
            )
        else {
            throw GameError("No target")
        }

        if useFreeAction {

            return try declareRunAction(
                playerID: targetPlayerID,
                isFree: true
            )

        } else {

            guard let targetPlayerSquare = table.getPlayer(id: targetPlayerID)?.square else {
                throw GameError("Target is in reserves")
            }

            events.append(
                .declinedCatchersInstinctsSkillRunAction(
                    playerID: targetPlayerID,
                    playerSquare: targetPlayerSquare
                )
            )
            return try endAction()
        }
    }
}
