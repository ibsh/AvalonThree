//
//  InGameTransaction+InputMessage+Action+Reserves+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareReservesAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> AddressedPrompt? {

        let emptySquares = Square
            .endZoneSquares(coachID: playerID.coachID)
            .filter({ square in
                table.squareIsUnobstructed(square)
                && table.squareIsEmptyOfPlayers(square)
            })

        // cannot be placed adjacent to an opponent or in a square containing a ball unless there is
        // no other option.

        let idealFinalSquares = emptySquares
            .filter { square in
                table.standingOpponentsAdjacentToSquare(square, for: playerID).isEmpty
                && table.looseBalls(in: square).isEmpty
            }

        let validFinalSquares = idealFinalSquares.isEmpty ? emptySquares : idealFinalSquares

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .reserves
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

        let validSquares = ValidMoveSquares(
            intermediate: [],
            final: validFinalSquares.toSet()
        )

        history.append(.reservesValidSquares(validSquares))
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: nil)
        )

        return AddressedPrompt(
            coachID: playerID.coachID,
            prompt: .reservesActionSelectSquare(playerID: playerID, validSquares: validSquares)
        )
    }
}
