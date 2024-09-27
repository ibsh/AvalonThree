//
//  InGameTransaction+InputMessage+Action+HurlTeammate+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareHurlTeammateAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> Prompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        let validTeammates = table
            .playersInSquares(playerSquare.adjacentSquares)
            .filter { possibleTeammate in
                possibleTeammate.coachID == player.coachID
                && possibleTeammate.index != player.index
            }
            .map { $0.id }
            .toSet()

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .hurlTeammate
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
        history.append(.hurlTeammateValidTeammates(validTeammates))
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )

        return Prompt(
            coachID: playerID.coachID,
            payload: .hurlTeammateActionSpecifyTeammate(
                playerID: playerID,
                validTeammates: validTeammates
            )
        )
    }
}
