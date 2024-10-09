//
//  InGameTransaction+InputMessage+Action+Block+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareBlockAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> AddressedPrompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        let validTargetPlayers = {
            if player.spec.skills.contains(.bomber),
               table.playerIsMarked(player) == nil
            {
                return table
                    .playersInSquares(
                        playerSquare.naiveNeighbourhood(distance: TableConstants.maxBombDistance)
                    )
                    .filter { possibleTarget in
                        possibleTarget.coachID != player.coachID
                        && possibleTarget.isStanding != nil
                    }
            } else {
                return table
                    .playersInSquares(playerSquare.adjacentSquares)
                    .filter { possibleTarget in
                        possibleTarget.coachID != player.coachID
                        && possibleTarget.isStanding != nil
                    }
            }
        }()

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .block
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

        if table.getActiveBonuses(coachID: playerID.coachID).contains(
            where: { $0.bonusPlay == .divingTackle }
        ) {
            history.append(.blockIsDivingTackle)
        }

        history.append(
            .blockValidTargets(validTargetPlayers.map { $0.id }.toSet())
        )
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )

        if validTargetPlayers.count == 1 {

            return try blockActionSelectTarget(
                target: validTargetPlayers.first!.id
            )

        } else {

            return AddressedPrompt(
                coachID: playerID.coachID,
                prompt: .blockActionSelectTarget(
                    playerID: playerID,
                    playerSquare: playerSquare,
                    validTargets: try validTargetPlayers.reduce([:]) { partialResult, player in
                        guard let playerSquare = player.square else {
                            throw GameError("Player is in reserves")
                        }
                        return partialResult.adding(
                            key: player.id,
                            value: playerSquare
                        )
                    }
                )
            )
        }
    }
}
