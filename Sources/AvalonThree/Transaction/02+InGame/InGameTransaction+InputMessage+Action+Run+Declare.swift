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
    ) throws -> Prompt? {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        let playerSquare: Square = try {
            if player.spec.skills.contains(.warMachine) {
                guard let square = player.isStanding else {
                    throw GameError("Player is not standing")
                }
                return square
            } else {
                guard let square = table.playerIsOpen(player) else {
                    throw GameError("Player is not open")
                }
                return square
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

        let maxRunDistance: Int
        if table.getActiveBonuses(coachID: playerID.coachID).contains(
            where: { $0.bonusPlay == .readyToGo }
        ) {
            maxRunDistance = TableConstants.readyToGoBonusPlayMaxRunDistance
        } else {
            switch player.spec.move {
            case .fixed(let fixed):
                maxRunDistance = fixed
            case .random(let randomizer):
                switch randomizer {
                case .d6:
                    maxRunDistance = randomizers.d6.roll()
                    events.append(.rolledForMaxRunDistance(maxRunDistance: maxRunDistance))
                }
            }
        }

        let validSquares = try validMoveSquares(
            playerID: playerID,
            playerSquare: playerSquare,
            moveReason: .run,
            maxDistance: maxRunDistance
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
                maxRunDistance: maxRunDistance,
                validSquares: validSquares
            )
        )
        events.append(.declaredAction(declaration: declaration, isFree: isFree))

        return try declaredRunAction()
    }
}
