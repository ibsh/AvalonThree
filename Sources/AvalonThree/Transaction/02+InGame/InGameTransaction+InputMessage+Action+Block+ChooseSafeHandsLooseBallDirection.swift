//
//  InGameTransaction+InputMessage+Action+Block+ChooseSafeHandsLooseBallDirection.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionSelectSafeHandsLooseBallDirection(
        direction: Direction
    ) throws -> AddressedPrompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            ),
            let directions = actionContext.history.lastResult(
                { entry -> Set<Direction>? in
                    guard case .blockSafeHandsDirections(let directions) = entry else { return nil }
                    return directions
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        guard directions.contains(direction) else {
            throw GameError("Invalid direction")
        }

        guard let newBallID = table.looseBalls(in: targetSquare).first?.id else {
            throw GameError("No loose ball to bounce")
        }

        events.append(
            .selectedLooseBallDirection(
                playerID: targetPlayerID,
                playerSquare: targetSquare,
                direction: direction
            )
        )

        try bounceBall(id: newBallID, direction: direction)

        return try blockActionRollForArmour()
    }
}
