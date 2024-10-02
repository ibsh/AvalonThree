//
//  InGameTransaction+AddNewBall.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func addNewBall(
        bounce: Bool = true
    ) throws {

        let turnContext = try history.latestTurnContext()

        let trapdoorSquares = table.boardSpecID.spec.trapdoorSquares
        guard !trapdoorSquares.isEmpty else {
            fatalError("No trap doors on this board")
        }

        let trapdoorSquare: Square
        if trapdoorSquares.count == 1 {
            trapdoorSquare = trapdoorSquares.first!
        } else {
            trapdoorSquare = randomizers.trapdoor.selectRandomTrapdoor(from: trapdoorSquares)
            events.append(
                .rolledForTrapdoor(
                    coachID: turnContext.coachID,
                    trapdoorSquare: trapdoorSquare
                )
            )
        }

        if let player = table.playerInSquare(trapdoorSquare) {
            try playerIsInjured(playerID: player.id, reason: .trapdoor)
        }

        for looseBall in table.looseBalls(in: trapdoorSquare) {
            try ballDisappears(id: looseBall.id, in: trapdoorSquare)
        }

        let newBall = Ball(
            idProvider: ballIDProvider,
            state: .loose(square: trapdoorSquare)
        )
        table.balls.insert(newBall)

        events.append(
            .newBallAppeared(ballID: newBall.id, ballSquare: trapdoorSquare)
        )

        if bounce {
            try bounceBall(id: newBall.id)
        }
    }
}
