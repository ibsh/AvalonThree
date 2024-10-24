//
//  File.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 10/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func checkForTouchdowns() throws {

        let turnContext = try history.latestTurnContext()

        let scoringPlayersAndBalls = table.playersInSquares(
            Square.endZoneSquares(coachID: turnContext.coachID.inverse)
        )
            .compactMap({ player -> (Player, Square, Ball)? in
                guard
                    player.coachID == turnContext.coachID,
                    let square = table.playerIsOpen(player),
                    let ball = table.playerHasABall(player)
                else {
                    return nil
                }
                return (player, square, ball)
            })

        for (scoringPlayer, square, ball) in scoringPlayersAndBalls {
            var scoringPlayer = scoringPlayer
            scoringPlayer.state = .inReserves
            table.players.update(with: scoringPlayer)
            table.incrementScore(
                coachID: turnContext.coachID,
                increment: TableConstants.touchdownScoreValue
            )
            history.append(.touchdown)
            table.balls.remove(ball)

            events.append(
                .playerScoredTouchdown(
                    playerID: scoringPlayer.id,
                    playerSquare: square,
                    ballID: ball.id
                )
            )
            events.append(
                .scoreUpdated(
                    coachID: scoringPlayer.coachID,
                    increment: TableConstants.touchdownScoreValue,
                    total: table.getScore(coachID: scoringPlayer.coachID)
                )
            )

            try checkForLegUpBonusPlay()
        }
    }
}
