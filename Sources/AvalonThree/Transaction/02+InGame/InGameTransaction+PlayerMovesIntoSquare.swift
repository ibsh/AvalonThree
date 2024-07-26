//
//  InGameTransaction+PlayerMovesIntoSquare.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

enum CanMoveIntoSquare {
    case canMove
    case cannotMove(reason: String)
}

extension InGameTransaction {

    mutating func playerMovesIntoSquare(
        playerID: PlayerID,
        newSquare: Square,
        isFinalSquare: Bool,
        reason: PlayerMoveReason
    ) throws {

        guard var player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        switch reason {
        case .run:
            guard let oldSquare = player.isStanding else {
                throw GameError("Player is not standing")
            }

            guard newSquare.isAdjacent(to: oldSquare) else {
                throw GameError("New square is not adjacent to old square")
            }

        case .sidestep:
            guard let oldSquare = player.isStanding else {
                throw GameError("Player is not standing")
            }

            guard newSquare.isAdjacent(to: oldSquare) else {
                throw GameError("New square is not adjacent to old square")
            }

        case .mark:
            guard let oldSquare = player.isStanding else {
                throw GameError("Player is not standing")
            }

            guard newSquare.isAdjacent(to: oldSquare) else {
                throw GameError("New square is not adjacent to old square")
            }

        case .shoved,
             .followUp,
             .shadow:
            guard let oldSquare = player.isStanding else {
                throw GameError("Player is not standing")
            }

            guard newSquare.isAdjacent(to: oldSquare) else {
                throw GameError("New square is not adjacent to old square")
            }

        case .reserves:
            break
        }

        switch try playerCanMoveIntoSquare(
            playerID: playerID,
            newSquare: newSquare,
            isFinalSquare: isFinalSquare,
            reason: reason
        ) {
        case .canMove:
            break
        case .cannotMove(let reason):
            throw GameError(reason)
        }

        player.state = .standing(square: newSquare)
        table.players.update(with: player)

        events.append(
            .playerMoved(playerID: playerID, square: newSquare, reason: reason)
        )

        while true {

            let looseBalls = table.looseBalls(in: newSquare)

            if looseBalls.isEmpty {
                break
            }

            // This should only ever be one, but still
            for ball in looseBalls {
                guard let newPlayer = table.getPlayer(id: playerID) else {
                    throw GameError("No player")
                }
                player = newPlayer

                if player.spec.skills.contains(.handlingSkills) {
                    try pickUpLooseBall(
                        player: player,
                        ball: ball
                    )
                } else {
                    switch reason {
                    case .run:
                        try pickUpLooseBall(
                            player: player,
                            ball: ball
                        )
                    case .reserves,
                         .sidestep,
                         .mark,
                         .shoved,
                         .followUp,
                         .shadow:
                        try bounceBall(id: ball.id)
                    }
                }
            }
        }
    }

    private mutating func pickUpLooseBall(
        player: Player,
        ball: Ball
    ) throws {
        if table.playerHasABall(player) != nil || player.spec.pass == nil {
            try bounceBall(id: ball.id)
        } else {
            var ball = ball
            ball.state = .held(playerID: player.id)
            table.balls.update(with: ball)

            events.append(.playerPickedUpLooseBall(playerID: player.id, ballID: ball.id))
        }
    }

    func playerCanMoveIntoSquare(
        playerID: PlayerID,
        newSquare: Square,
        isFinalSquare: Bool,
        reason: PlayerMoveReason
    ) throws -> CanMoveIntoSquare {

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        switch reason {
        case .run:
            guard player.isStanding != nil else {
                throw GameError("Player is not standing")
            }

            var requireUnobstructed = true
            var requireEmptyOfPlayers = true
            var requireUnmarked = true

            if isFinalSquare {

                requireUnmarked = false
                for opponent in table.standingOpponentsAdjacentToSquare(newSquare, for: playerID)
                where !opponent.spec.skills.contains(.titchy)
                && !opponent.spec.skills.contains(.insignificant)
                {
                    requireUnmarked = true
                }

                if player.spec.skills.contains(.rush)
                    || player.spec.skills.contains(.warMachine)
                    || table.getActiveBonuses(coachID: playerID.coachID)
                    .contains(where: { $0.bonusPlay == .blockingPlay })
                {
                    requireUnmarked = false
                }

            } else {

                if player.spec.skills.contains(.ethereal) {
                    requireUnobstructed = false
                }

                if player.spec.skills.contains(.leap) {
                    requireEmptyOfPlayers = false
                }

                if player.spec.skills.contains(.ethereal)
                    || player.spec.skills.contains(.leap)
                    || player.spec.skills.contains(.elusive)
                    || player.spec.skills.contains(.warMachine)
                    || table.getActiveBonuses(coachID: playerID.coachID)
                    .contains(where: { $0.bonusPlay == .dodge })
                {
                    requireUnmarked = false
                }
            }

            let squareDef = isFinalSquare ? "Final" : "New"

            if requireUnobstructed {
                guard table.squareIsUnobstructed(newSquare) else {
                    return .cannotMove(reason: "\(squareDef) square is obstructed")
                }
            }

            if requireEmptyOfPlayers {
                if let playerInSquare = table.playerInSquare(newSquare) {
                    guard playerInSquare.id == playerID else {
                        return .cannotMove(reason: "\(squareDef) square is not empty")
                    }
                }
            }

            if requireUnmarked {
                for opponent in table.standingOpponentsAdjacentToSquare(newSquare, for: playerID) {
                    if opponent.spec.skills.contains(.insignificant) {
                        continue
                    } else {
                        return .cannotMove(reason: "\(squareDef) square is marked")
                    }
                }
            }

        case .sidestep:
            guard player.isStanding != nil else {
                throw GameError("Player is not standing")
            }

            guard table.squareIsUnobstructed(newSquare) else {
                return .cannotMove(reason: "New square is obstructed")
            }

            guard table.squareIsEmptyOfPlayers(newSquare) else {
                return .cannotMove(reason: "New square is not empty")
            }

            if isFinalSquare {
                guard table.standingOpponentsAdjacentToSquare(
                    newSquare,
                    for: playerID
                ).isEmpty else {
                    return .cannotMove(reason: "Invalid squares")
                }
            }

        case .mark:
            guard player.isStanding != nil else {
                throw GameError("Player is not standing")
            }

            guard table.squareIsUnobstructed(newSquare) else {
                return .cannotMove(reason: "New square is obstructed")
            }

            if let playerInSquare = table.playerInSquare(newSquare) {
                guard playerInSquare.id == playerID else {
                    return .cannotMove(reason: "New square is not empty")
                }
            }

            if isFinalSquare {
                guard
                    !table
                        .standingOpponentsAdjacentToSquare(newSquare, for: playerID)
                        .isEmpty
                else {
                    return .cannotMove(reason: "Final square does not mark any opponents")
                }
            }

        case .shoved,
             .followUp,
             .shadow:
            guard player.isStanding != nil else {
                throw GameError("Player is not standing")
            }

            guard table.squareIsUnobstructed(newSquare) else {
                return .cannotMove(reason: "New square is obstructed")
            }

            guard table.squareIsEmptyOfPlayers(newSquare) else {
                return .cannotMove(reason: "New square is not empty")
            }

        case .reserves:
            guard player.isInReserves else {
                throw GameError("Player is not in reserves")
            }

            guard table.squareIsUnobstructed(newSquare) else {
                return .cannotMove(reason: "New square is obstructed")
            }

            guard table.squareIsEmptyOfPlayers(newSquare) else {
                return .cannotMove(reason: "New square is not empty")
            }
        }

        return .canMove
    }
}
