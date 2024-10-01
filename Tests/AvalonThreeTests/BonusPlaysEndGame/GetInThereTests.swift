//
//  GetInThereTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct GetInThereTests {

    @Test func usedAfterFallingThroughTrapdoorAtBeginningOfPlayersTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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

        ballIDProvider.nextResults = [456]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
                .turnEnded,
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorAtBeginningOfPlayersTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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

        ballIDProvider.nextResults = [456]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
                .turnEnded,
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAfterFallingThroughTrapdoorAtBeginningOfOpponentsTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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

        ballIDProvider.nextResults = [456]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
                .turnEnded,
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorAtBeginningOfOpponentsTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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

        ballIDProvider.nextResults = [456]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
                .turnEnded,
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAfterFallingThroughTrapdoorDuringPlayersTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .showThemHowItsDone,
                            bonusPlay: .multiBall
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)

        // Claim objective

        ballIDProvider.nextResults = [456, 789]
        directionRandomizer.nextResults = [.northWest, .east]

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
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorDuringPlayersTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .showThemHowItsDone,
                            bonusPlay: .multiBall
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)

        // Claim objective

        ballIDProvider.nextResults = [456, 789]
        directionRandomizer.nextResults = [.northWest, .east]

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
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAfterFallingThroughTrapdoorDuringOpponentsTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .showThemHowItsDone,
                            bonusPlay: .multiBall
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)


        // Claim objective

        ballIDProvider.nextResults = [456, 789]
        directionRandomizer.nextResults = [.northWest, .east]

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
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)


        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )


        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorDuringOpponentsTurn() async throws {

        // Init

        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .showThemHowItsDone,
                            bonusPlay: .multiBall
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
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
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerScoredTouchdown,
                .scoreUpdated,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)

        // Claim objective

        ballIDProvider.nextResults = [456, 789]
        directionRandomizer.nextResults = [.northWest, .east]

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
                .playerInjured,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)


        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAfterBeingBlocked() async throws {

        // Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare block

        blockDieRandomizer.nextResults = [.kerrunch]
        d6Randomizer.nextResults = [2]

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .rolledForArmour,
                .changedArmourResult,
                .playerInjured,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )


        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)


        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterBeingBlocked() async throws {

        // Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare block

        blockDieRandomizer.nextResults = [.kerrunch]
        d6Randomizer.nextResults = [2]

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            )
        )


        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .rolledForArmour,
                .changedArmourResult,
                .playerInjured,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAfterBeingFouled() async throws {

        // Init

        let foulDieRandomizer = FoulDieRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .prone(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare foul

        foulDieRandomizer.nextResults = [.gotThem]

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForFoul,
                .playerFouled,
                .playerInjured,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterBeingFouled() async throws {

        // Init

        let foulDieRandomizer = FoulDieRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .prone(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(),
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare foul

        foulDieRandomizer.nextResults = [.gotThem]

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForFoul,
                .playerFouled,
                .playerInjured,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAfterBeingFumbled() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 1))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(),
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
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare hurl teammate

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
        #expect(latestPrompt?.payload.case == .hurlTeammateActionSpecifyTarget)

        // Specify target square

        d6Randomizer.nextResults = [1]
        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .rolledForHurlTeammate,
                .playerFumbledTeammate,
                .playerInjured,
                .ballCameLoose,
                .rolledForDirection,
                .ballBounced,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .reservesActionSpecifySquare)

        // Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedAfterBeingFumbled() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 1))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(),
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
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare hurl teammate

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
        #expect(latestPrompt?.payload.case == .hurlTeammateActionSpecifyTarget)

        // Specify target square

        d6Randomizer.nextResults = [1]
        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .rolledForHurlTeammate,
                .playerFumbledTeammate,
                .playerInjured,
                .ballCameLoose,
                .rolledForDirection,
                .ballBounced,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
