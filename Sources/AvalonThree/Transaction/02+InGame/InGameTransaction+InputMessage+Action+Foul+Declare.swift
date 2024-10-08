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
    ) throws -> AddressedPrompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = table.playerIsOpen(player) else {
            throw GameError("Player is not open")
        }

        let validTargetPlayers = table
            .playersInSquares(playerSquare.adjacentSquares)
            .filter { possibleTarget in
                possibleTarget.coachID != player.coachID
                && possibleTarget.isProne != nil
            }

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
        history.append(.foulValidTargets(validTargetPlayers.map { $0.id }.toSet()))
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )

        if validTargetPlayers.count == 1 {

            return try foulActionSelectTarget(
                target: validTargetPlayers.first!.id
            )

        } else {

            return AddressedPrompt(
                coachID: playerID.coachID,
                prompt: .foulActionSelectTarget(
                    player: PromptBoardPlayer(
                        id: playerID,
                        square: playerSquare
                    ),
                    validTargets: try validTargetPlayers.map { player in
                        guard let playerSquare = player.square else {
                            throw GameError("Player is in reserves")
                        }
                        return PromptBoardPlayer(
                            id: player.id,
                            square: playerSquare
                        )
                    }.toSet()
                )
            )
        }
    }
}
