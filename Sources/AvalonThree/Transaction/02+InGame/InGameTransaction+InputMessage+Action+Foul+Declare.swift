//
//  InGameTransaction+InputMessage+Action+Foul+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareFoulAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> Prompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = table.playerIsOpen(player) else {
            throw GameError("Player is not open")
        }

        let validTargets = table
            .playersInSquares(playerSquare.adjacentSquares)
            .filter { possibleTarget in
                possibleTarget.coachID != player.coachID
                && table.playerIsProne(possibleTarget) != nil
            }
            .map { $0.id }
            .toSet()

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .foul
        )

        // set the action
        history.append(
            .actionDeclaration(
                declaration: declaration,
                snapshot: ActionSnapshot(table: table)
            )
        )
        if isFree {
            history.append(.actionIsFree)
        }
        history.append(.foulValidTargets(validTargets))
        events.append(.declaredAction(declaration: declaration, isFree: isFree))

        return Prompt(
            coachID: playerID.coachID,
            payload: .foulActionSpecifyTarget(playerID: playerID, validTargets: validTargets)
        )
    }
}
