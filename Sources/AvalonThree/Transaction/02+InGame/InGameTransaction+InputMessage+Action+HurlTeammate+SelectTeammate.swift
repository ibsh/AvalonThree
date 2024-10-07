//
//  InGameTransaction+InputMessage+Action+HurlTeammate+SelectTeammate.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Foundation

extension InGameTransaction {

    mutating func hurlTeammateActionSelectTeammate(
        teammate teammateID: PlayerID
    ) throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let validTeammates = actionContext.history.lastResult(
                { entry -> Set<PlayerID>? in
                    guard case .hurlTeammateValidTeammates(let validTeammates) = entry else {
                        return nil
                    }
                    return validTeammates
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard validTeammates.contains(teammateID) else {
            throw GameError("Invalid teammate")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
        }

        let openOpponentSquares = table.players(coachID: actionContext.coachID.inverse)
            .compactMap { player in
                table.playerIsOpen(player)
            }

        let validTargets = Square.all.reduce(Set<HurlTeammateTarget>()) { set, targetSquare in
            guard
                table.squareIsUnobstructed(targetSquare),
                table.squareIsEmptyOfPlayers(targetSquare),
                let measure = playerSquare.measurePass(
                    to: targetSquare,
                    hailMaryPass: false
                )
            else {
                return set
            }
            let obstructingSquares = measure
                .touchingSquares
                .filter { square in
                    table.boardSpecID.spec.obstructedSquares.contains(square)
                    || openOpponentSquares.contains(square)
                }

            var distance = measure.distance
            switch distance {
            case .handoff:
                distance = .short
            case .short,
                 .long:
                break
            }

            return set.union([
                HurlTeammateTarget(
                    targetSquare: targetSquare,
                    distance: distance,
                    obstructingSquares: obstructingSquares
                )
            ])
        }

        // set the action
        history.append(.hurlTeammateTeammate(teammateID))
        history.append(.hurlTeammateValidTargets(validTargets))

        return Prompt(
            coachID: actionContext.coachID,
            payload: .hurlTeammateActionSelectTarget(
                playerID: actionContext.playerID,
                playerSquare: playerSquare,
                validTargets: validTargets
            )
        )
    }
}
