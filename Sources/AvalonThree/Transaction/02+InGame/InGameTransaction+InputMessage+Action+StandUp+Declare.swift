//
//  InGameTransaction+InputMessage+Action+StandUp+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareStandUpAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> Prompt? {

        guard var player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.isProne else {
            throw GameError("Player is not prone")
        }

        player.state = .standing(square: playerSquare)
        table.players.update(with: player)

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .standUp
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
        history.append(.actionFinished)
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )
        events.append(
            .playerStoodUp(playerID: playerID, in: playerSquare)
        )

        return try endAction()
    }
}
