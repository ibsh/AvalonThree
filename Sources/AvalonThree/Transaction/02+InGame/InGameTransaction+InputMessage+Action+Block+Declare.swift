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
    ) throws -> Prompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        let validTargetPlayerIDs = {
            if player.spec.skills.contains(.bomber),
               table.playerIsMarked(player) == nil
            {
                return table
                    .playersInSquares(
                        playerSquare.naiveNeighbourhood(distance: TableConstants.maxBombDistance)
                    )
                    .filter { possibleTarget in
                        possibleTarget.coachID != player.coachID
                        && player.isStanding != nil
                    }
                    .map { $0.id }
            } else {
                return table
                    .playersInSquares(playerSquare.adjacentSquares)
                    .filter { possibleTarget in
                        possibleTarget.coachID != player.coachID
                        && player.isStanding != nil
                    }
                    .map { $0.id }
            }
        }()
            .toSet()

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
            .blockValidTargets(validTargetPlayerIDs)
        )
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )

        if validTargetPlayerIDs.count == 1 {

            return try blockActionSpecifyTarget(
                target: validTargetPlayerIDs.first!
            )

        } else {

            return Prompt(
                coachID: playerID.coachID,
                payload: .blockActionSpecifyTarget(
                    playerID: playerID,
                    validTargets: validTargetPlayerIDs
                )
            )
        }
    }
}
