//
//  InGameTransaction+InputMessage+Action+Sidestep+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareSidestepAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> Prompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("No square")
        }

        let validSquares = try validMoveSquares(
            playerID: playerID,
            playerSquare: playerSquare,
            moveReason: .sidestep,
            maxDistance: TableConstants.maxSidestepDistance
        )

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .sidestep
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
        history.append(.sidestepValidSquares(validSquares))
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )

        return Prompt(
            coachID: playerID.coachID,
            payload: .sidestepActionSpecifySquare(playerID: playerID, validSquares: validSquares)
        )
    }
}
