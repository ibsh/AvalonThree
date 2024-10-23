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

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            ),
            randomizers: Randomizers(
                ballID: ballID(456),
                direction: direction(.northWest)
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(3, 14))
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorAtBeginningOfPlayersTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            ),
            randomizers: Randomizers(
                ballID: ballID(456),
                direction: direction(.northWest)
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterFallingThroughTrapdoorAtBeginningOfOpponentsTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            ),
            randomizers: Randomizers(
                ballID: ballID(456),
                direction: direction(.northWest)
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSelectSquare(square: sq(3, 0))
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorAtBeginningOfOpponentsTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            ),
            randomizers: Randomizers(
                ballID: ballID(456),
                direction: direction(.northWest)
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterFallingThroughTrapdoorDuringPlayersTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            ),
            randomizers: Randomizers(
                ballID: ballID(456, 456, 456, 456, 456, 789),
                direction: direction(.northWest, .east)
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSelectSquare(square: sq(3, 0))
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorDuringPlayersTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            ),
            randomizers: Randomizers(
                ballID: ballID(456, 789),
                direction: direction(.northWest, .east)
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterFallingThroughTrapdoorDuringOpponentsTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            ),
            randomizers: Randomizers(
                ballID: ballID(456, 789),
                direction: direction(.northWest, .east)
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(3, 14))
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterFallingThroughTrapdoorDuringOpponentsTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            ),
            randomizers: Randomizers(
                ballID: ballID(456, 789),
                direction: direction(.northWest, .east)
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterBeingBlocked() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.kerrunch), d6: d6(2))
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterBeingBlocked() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.kerrunch), d6: d6(2))
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterBeingFouled() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.gotThem))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForFoul,
                .playerFouled,
                .playerInjured,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterBeingFouled() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.gotThem))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForFoul,
                .playerFouled,
                .playerInjured,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterBeingFumbled() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .hurlTeammateActionSelectTarget)

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(7, 6))
            ),
            randomizers: Randomizers(d6: d6(1), direction: direction(.west))
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSelectSquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterBeingFumbled() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .hurlTeammateActionSelectTarget)

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(7, 6))
            ),
            randomizers: Randomizers(d6: d6(1), direction: direction(.west))
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForGetInThereBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
