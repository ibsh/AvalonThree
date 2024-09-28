//
//  InGameTransaction+ValidDeclarations.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/29/24.
//

import Foundation

enum CanDeclareAction: Equatable {
    case canDeclare(consumesBonusPlays: [BonusPlay])
    case cannotDeclare
}

extension InGameTransaction {

    func validDeclarations() throws -> Set<ValidDeclaration> {

        let turnContext = try history.latestTurnContext()

        guard try !turnContext.actionContexts().contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        return try validDeclarations(coachID: turnContext.coachID)
    }

    func validDeclarations(coachID: CoachID) throws -> Set<ValidDeclaration> {
        try table.players(coachID: coachID).reduce(Set<ValidDeclaration>()) { outer, player in
            outer.union(
                try ActionID.allCases.reduce(Set<ValidDeclaration>()) { inner, actionID in
                    switch try playerCanDeclareAction(player: player, actionID: actionID) {
                    case .canDeclare(let consumesBonusPlays):
                        inner.union(
                            [
                                ValidDeclaration(
                                    declaration: ActionDeclaration(
                                        playerID: player.id,
                                        actionID: actionID
                                    ),
                                    consumesBonusPlays: consumesBonusPlays
                                )
                            ]
                        )
                    case .cannotDeclare:
                        inner
                    }
                }
            )
        }
    }

    func playerCanDeclareAction(
        player: Player,
        actionID: ActionID
    ) throws -> CanDeclareAction {

        guard player.canTakeActions else { return .cannotDeclare }

        for actionContext in try history.latestTurnContext().actionContexts() {
            if
                actionContext.playerID == player.id
                    && actionContext.actionID.isEquivalentTo(actionID)
                    && !actionContext.isCancelled
            {
                return .cannotDeclare
            }
        }

        switch actionID {
        case .run:
            return try playerCanDeclareRunAction(
                player: player
            )
        case .mark:
            return try playerCanDeclareMarkAction(
                player: player
            )
        case .pass:
            return try playerCanDeclarePassAction(
                player: player
            )
        case .hurlTeammate:
            return try playerCanDeclareHurlTeammateAction(
                player: player
            )
        case .foul:
            return try playerCanDeclareFoulAction(
                player: player
            )
        case .block:
            return try playerCanDeclareBlockAction(
                player: player
            )
        case .sidestep:
            return try playerCanDeclareSidestepAction(
                player: player
            )
        case .standUp:
            return try playerCanDeclareStandUpAction(
                player: player
            )
        case .reserves:
            return try playerCanDeclareReservesAction(
                player: player
            )
        }
    }

    func playerActionsTaken() throws -> Int {
        try history.latestTurnContext().actionContexts()
            .count(where: { !$0.isFree && !$0.isCancelled })
    }

    func playerActionsLeft() throws -> Int {
        try TableConstants.maxPlayerActionsPerTurn - playerActionsTaken()
    }

    private func playerCanDeclareRunAction(
        player: Player
    ) throws -> CanDeclareAction {

        if player.spec.skills.contains(.ethereal) || player.spec.skills.contains(.warMachine) {
            return player.isStanding == nil
            ? .cannotDeclare
            : .canDeclare(consumesBonusPlays: [])
        } else {
            return table.playerIsOpen(player) == nil
            ? .cannotDeclare
            : .canDeclare(consumesBonusPlays: [])
        }
    }

    private func playerCanDeclareMarkAction(
        player: Player
    ) throws -> CanDeclareAction {

        if try !opponentsThatCanBeMarked(
            player: player,
            maxMarkDistance: TableConstants.maxMarkDistance
        ).isEmpty {
            return .canDeclare(consumesBonusPlays: [])
        }

        let bonusPlay = BonusPlay.interference

        if table.getHand(coachID: player.coachID).contains(
            where: { $0.bonusPlay == bonusPlay }
        ),
            try !opponentsThatCanBeMarked(
                player: player,
                maxMarkDistance: TableConstants.interferenceBonusPlayMaxMarkDistance
            ).isEmpty
        {
            return .canDeclare(consumesBonusPlays: [bonusPlay])
        }

        return .cannotDeclare
    }

    func opponentsThatCanBeMarked(
        player: Player,
        maxMarkDistance: Int
    ) throws -> Set<PlayerID> {

        guard let playerSquare = table.playerIsOpen(player) else {
            return []
        }

        return try playerSquare
            .naiveNeighbourhood(distance: maxMarkDistance)
            .flatMap { square in
                let opponentIDs = table
                    .standingOpponentsAdjacentToSquare(square, for: player.id)
                    .map { $0.id }
                guard
                    !opponentIDs.isEmpty,
                    let path = try Square.optimalPath(
                        from: playerSquare,
                        to: square,
                        isValid: buildMoveValidationFunction(playerID: player.id, reason: .mark)
                    ),
                    path.count <= maxMarkDistance
                else { return [PlayerID]() }
                return opponentIDs
            }
            .toSet()
    }

    private func playerCanDeclarePassAction(
        player: Player
    ) throws -> CanDeclareAction {

        guard
            let square = player.isStanding,
            player.spec.pass != nil,
            table.playerHasABall(player) != nil
        else { return .cannotDeclare }

        var consumesBonusPlays: [BonusPlay] = []

        if table.playerIsMarked(player) != nil {
            if table.getHand(coachID: player.coachID).contains(
                where: { $0.bonusPlay == .nervesOfSteel }
            ) {
                consumesBonusPlays.append(.nervesOfSteel)
            } else {
                return .cannotDeclare
            }
        }

        func validTeammate(teammate: Player, hailMaryPass: Bool) -> Bool {
            guard
                teammate.id != player.id,
                let targetSquare = teammate.isStanding,
                table.playerHasABall(teammate) == nil,
                square.measurePass(
                    to: targetSquare,
                    hailMaryPass: hailMaryPass
                ) != nil
            else { return false }
            return true
        }

        if table
            .players(coachID: player.coachID)
            .contains(where: { validTeammate(teammate: $0, hailMaryPass: false) })
        {
            return .canDeclare(consumesBonusPlays: consumesBonusPlays)
        }

        if
            table.getHand(coachID: player.coachID).contains(
                where: { $0.bonusPlay == .hailMaryPass }
            ),
            table
                .players(coachID: player.coachID)
                .contains(where: { validTeammate(teammate: $0, hailMaryPass: true) })
        {
            consumesBonusPlays.append(.hailMaryPass)
            return .canDeclare(consumesBonusPlays: consumesBonusPlays)
        }

        return .cannotDeclare
    }

    private func playerCanDeclareHurlTeammateAction(
        player: Player
    ) throws -> CanDeclareAction {

        guard
            player.spec.skills.contains(.hurlTeammate),
            player.spec.pass != nil,
            let square = player.isStanding,
            table.playerHasABall(player) == nil,
            table
                .playersInSquares(square.adjacentSquares)
                .contains(where: { adjacentPlayer in
                    adjacentPlayer.coachID == player.coachID
                    && adjacentPlayer.spec != player.spec
                    && adjacentPlayer.isStanding != nil
                })
        else {
            return .cannotDeclare
        }

        var consumesBonusPlays: [BonusPlay] = []

        if table.playerIsMarked(player) != nil {
            if table.getHand(coachID: player.coachID).contains(
                where: { $0.bonusPlay == .nervesOfSteel }
            ) {
                consumesBonusPlays.append(.nervesOfSteel)
            } else {
                return .cannotDeclare
            }
        }

        return .canDeclare(consumesBonusPlays: consumesBonusPlays)
    }

    private func playerCanDeclareFoulAction(
        player: Player
    ) throws -> CanDeclareAction {

        guard
            let square = table.playerIsOpen(player),
            table
                .players(coachID: player.coachID.inverse)
                .contains(where: { opponent in
                    guard let opponentSquare = opponent.isProne else { return false }
                    return square.adjacentSquares.contains(opponentSquare)
                })
        else {
            return .cannotDeclare
        }

        return .canDeclare(consumesBonusPlays: [])
    }

    private func playerCanDeclareBlockAction(
        player: Player
    ) throws -> CanDeclareAction {

        guard let playerSquare = player.square else { return .cannotDeclare }

        if player.spec.skills.contains(.bomber),
            table.playerIsMarked(player) == nil
        {
            if table
                .players(coachID: player.coachID.inverse)
                .contains(where: { opponent in
                    guard let targetSquare = opponent.isStanding else { return false }
                    return targetSquare
                        .naiveDistance(to: playerSquare) <= TableConstants.maxBombDistance
                })
            {
                return .canDeclare(consumesBonusPlays: [])
            }
        }

        if table.playerIsMarked(player) == nil {
            return .cannotDeclare
        } else {
            return .canDeclare(consumesBonusPlays: [])
        }
    }

    private func playerCanDeclareSidestepAction(
        player: Player
    ) throws -> CanDeclareAction {

        guard let playerSquare = table.playerIsMarked(player) else { return .cannotDeclare }

        let validSquares = try playerSquare
            .adjacentSquares
            .filter { destination in
                switch try playerCanMoveIntoSquare(
                    playerID: player.id,
                    newSquare: destination,
                    isFinalSquare: true,
                    reason: .sidestep
                ) {
                case .canMove:
                    return true
                case .cannotMove:
                    return false
                }
            }

        if validSquares.isEmpty {
            return .cannotDeclare
        } else {
            return .canDeclare(consumesBonusPlays: [])
        }
    }

    private func playerCanDeclareStandUpAction(
        player: Player
    ) throws -> CanDeclareAction {
        if player.isProne == nil {
            return .cannotDeclare
        } else {
            return .canDeclare(consumesBonusPlays: [])
        }
    }

    private func playerCanDeclareReservesAction(
        player: Player
    ) throws -> CanDeclareAction {

        guard
            player.isInReserves,
            Square
                .endZoneSquares(coachID: player.coachID)
                .contains(where: { square in
                    table.squareIsUnobstructed(square) && table.squareIsEmptyOfPlayers(square)
                })
        else {
            return .cannotDeclare
        }

        return .canDeclare(consumesBonusPlays: [])
    }
}
