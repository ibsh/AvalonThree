//
//  YourTimeToShineTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct YourTimeToShineTests {

    @Test func useFreeActions() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .noble
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .noble_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .noble_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .noble_passer,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .noble_blitzer,
                            state: .standing(square: sq(8, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .loose(square: sq(5, 6))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .yourTimeToShine
                        )
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare reserves

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .reserves
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(6, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerPickedUpLooseBall,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .claimedObjective,
                .scoreUpdated,
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForYourTimeToShineBonusPlayReservesAction)

        // Use reserves action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useYourTimeToShineBonusPlayReservesAction(
                    playerID: pl(.away, 3)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(2, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForYourTimeToShineBonusPlayReservesAction)

        // Use reserves action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useYourTimeToShineBonusPlayReservesAction(
                    playerID: pl(.away, 4)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(8, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForYourTimeToShineBonusPlayRunAction)

        // Use run action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useYourTimeToShineBonusPlayRunAction(
                    playerID: pl(.away, 3)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(1, 1),
                        sq(0, 2),
                        sq(0, 3),
                        sq(0, 4),
                        sq(1, 5),
                        sq(2, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declineFreeActions() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .noble
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .noble_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .noble_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .noble_passer,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .noble_blitzer,
                            state: .standing(square: sq(8, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .loose(square: sq(5, 6))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .yourTimeToShine
                        )
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerPickedUpLooseBall,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .claimedObjective,
                .scoreUpdated,
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForYourTimeToShineBonusPlayReservesAction)

        // Decline reserves action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineYourTimeToShineBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForYourTimeToShineBonusPlayReservesAction)

        // Decline reserves action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineYourTimeToShineBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
