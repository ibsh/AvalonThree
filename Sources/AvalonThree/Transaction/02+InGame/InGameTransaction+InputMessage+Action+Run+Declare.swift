//
//  InGameTransaction+InputMessage+Action+Run+Declare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareRunAction(
        playerID: PlayerID,
        isFree: Bool
    ) throws -> AddressedPrompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        let playerSquare: Square = try {
            if player.spec.skills.contains(.warMachine) {
                guard let playerSquare = player.isStanding else {
                    throw GameError("Player is not standing")
                }
                return playerSquare
            } else {
                guard let playerSquare = table.playerIsOpen(player) else {
                    throw GameError("Player is not open")
                }
                return playerSquare
            }
        }()

        if !player.spec.skills.contains(.ethereal) {
            guard playerSquare
                .adjacentSquares
                .contains(
                    where: { table.standingOpponentsAdjacentToSquare($0, for: playerID).isEmpty }
                )
            else {
                throw GameError("Player has nowhere to go")
            }
        }

        let maxDistance: Int
        if table.getActiveBonuses(coachID: playerID.coachID).contains(
            where: { $0.bonusPlay == .readyToGo }
        ) {
            maxDistance = TableConstants.readyToGoBonusPlayMaxRunDistance
        } else {
            switch player.spec.move {
            case .fixed(let fixed):
                maxDistance = fixed
            case .d6:
                maxDistance = randomizers.d6.roll()
                events.append(
                    .rolledForMaxRunDistance(
                        coachID: playerID.coachID,
                        maxDistance: maxDistance
                    )
                )
            }
        }

        let validSquares = try validMoveSquares(
            playerID: playerID,
            playerSquare: playerSquare,
            moveReason: .run,
            maxDistance: maxDistance
        )

        let declaration = ActionDeclaration(
            playerID: playerID,
            actionID: .run
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
        history.append(
            .runValidSquares(
                maxDistance: maxDistance,
                validSquares: validSquares
            )
        )
        events.append(
            .declaredAction(declaration: declaration, isFree: isFree, playerSquare: playerSquare)
        )

        return try declaredRunAction()
    }
}
