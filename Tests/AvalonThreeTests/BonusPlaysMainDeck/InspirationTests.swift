//
//  InspirationTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct InspirationTests {

    @Test func turnEndsIfDeclined() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineInspirationBonusPlayFreeAction
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

    @Test func takeFreeRunAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .run
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
                    sq(6, 4),
                    sq(7, 5),
                    sq(8, 5),
                    sq(9, 6),
                    sq(10, 7),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeMarkAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 6),
                        actionID: .mark
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(5, 5),
                    sq(6, 6),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreePassAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .pass
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .passActionSelectTarget)

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(
                    target: pl(CoachID.away, 5)
                )
            ),
            randomizers: Randomizers(d6: d6(2), direction: direction(.west))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .rolledForPass,
                .changedPassResult,
                .playerFumbledBall,
                .ballCameLoose,
                .rolledForDirection,
                .ballBounced,
                .playerCaughtBouncingBall,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeHurlTeammateAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free hurl teammate

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 6),
                        actionID: .hurlTeammate
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .hurlTeammateActionSelectTarget)

        // Select target

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(
                    targetSquare: sq(10, 10)
                )
            ),
            randomizers: Randomizers(d6: d6(4), direction: direction(.southEast))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .rolledForHurlTeammate,
                .changedHurlTeammateResult,
                .playerHurledTeammate,
                .hurledTeammateCrashed,
                .ballCameLoose,
                .rolledForDirection,
                .changedDirection,
                .ballBounced,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeFoulAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free foul

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.gotThem))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
                .rolledForFoul,
                .playerFouled,
                .playerInjured,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeBlockAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.shove))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .blockActionEligibleForFollowUp)

        // Decline followup

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineFollowUp
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declinedFollowUp,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeSidestepAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .sidestep
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .sidestepActionSelectSquare)

        // Select sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSelectSquare(square: sq(9, 7))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeStandUpAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free stand up

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 4),
                        actionID: .standUp
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
                .playerStoodUp,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func takeFreeReservesAction() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .reserves
                    ),
                    consumesBonusPlays: []
                )
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
                message: .reservesActionSelectSquare(square: sq(6, 0))
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

    @Test func cantUseTwiceInOneTurn() async throws {

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
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .breakTheirLines, bonusPlay: .inspiration),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 2))
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
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
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
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForInspirationBonusPlayFreeAction)

        // Declare free reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .reserves
                    ),
                    consumesBonusPlays: []
                )
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
                message: .reservesActionSelectSquare(square: sq(6, 0))
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

    @Test func usedWithConsumedBonusPlays() async throws {

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .away,
                        boardSpecID: BoardSpecID.season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
                        rookieBonusRecipientID: RookieBonusRecipientID.noOne,
                        coinFlipWinnerTeamID: TeamID.snotling,
                        coinFlipLoserTeamID: TeamID.skaven
                    ),
                    players: [
                        Player(id: PlayerID(coachID: .home, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 14)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .home, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 2)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .home, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(5, 8)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .home, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 3, armour: 4, skills: [.handlingSkills]), state: .standing(square: sq(4, 14)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .home, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(9), block: 1, pass: 4, armour: 5, skills: [.safeHands]), state: .inReserves, canTakeActions: true),
                        Player(id: PlayerID(coachID: .home, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: 3, skills: [.offensiveSpecialist]), state: .standing(square: sq(4, 5)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(9, 5)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(0, 4)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(7, 0)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(3, 3)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(6, 4)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(10, 5)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 6), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 4, armour: nil, skills: [.bomber]), state: .standing(square: sq(7, 5)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 7), spec: PlayerSpec(move: PlayerSpec.Move.fixed(6), block: 1, pass: 5, armour: nil, skills: [.leap]), state: .standing(square: sq(6, 0)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 8), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: nil, skills: []), state: .standing(square: sq(4, 0)), canTakeActions: true),
                        Player(id: PlayerID(coachID: .away, index: 9), spec: PlayerSpec(move: PlayerSpec.Move.d6, block: 3, pass: nil, armour: 3, skills: [.warMachine]), state: .inReserves, canTakeActions: true),
                    ],
                    playerNumbers: [
                        PlayerID(coachID: .away, index: 4): 43,
                        PlayerID(coachID: .away, index: 8): 23,
                        PlayerID(coachID: .home, index: 1): 22,
                        PlayerID(coachID: .away, index: 0): 50,
                        PlayerID(coachID: .home, index: 2): 15,
                        PlayerID(coachID: .away, index: 3): 68,
                        PlayerID(coachID: .away, index: 6): 93,
                        PlayerID(coachID: .home, index: 5): 35,
                        PlayerID(coachID: .away, index: 1): 11,
                        PlayerID(coachID: .home, index: 4): 96,
                        PlayerID(coachID: .away, index: 2): 76,
                        PlayerID(coachID: .home, index: 0): 49,
                        PlayerID(coachID: .away, index: 9): 67,
                        PlayerID(coachID: .home, index: 3): 78,
                        PlayerID(coachID: .away, index: 5): 89,
                        PlayerID(coachID: .away, index: 7): 18
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .getTheBall, bonusPlay: .distraction)
                    ],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .takeThemDown, bonusPlay: .divingTackle),
                        ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .getMoving, bonusPlay: .interference)
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 1,
                    coinFlipWinnerScore: 6,
                    balls: [
                        Ball(id: 38, state: Ball.State.held(playerID: PlayerID(coachID: .home, index: 1)))
                    ],
                    deck: [
                        ChallengeCard(challenge: .getMoving, bonusPlay: .sprint),
                        ChallengeCard(challenge: .showUsACompletion, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                        ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .blitz),
                        ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .intervention),
                        ChallengeCard(challenge: .tieThemUp, bonusPlay: .defensivePlay),
                        ChallengeCard(challenge: .showNoFear, bonusPlay: .jumpUp),
                        ChallengeCard(challenge: .gangUp, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .spreadOut, bonusPlay: .reserves),
                        ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .rawTalent),
                        ChallengeCard(challenge: .moveTheBall, bonusPlay: .dodge),
                        ChallengeCard(challenge: .getTogether, bonusPlay: .reserves),
                        ChallengeCard(challenge: .tieThemUp, bonusPlay: .rawTalent),
                        ChallengeCard(challenge: .getTheBall, bonusPlay: .shadow),
                        ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .multiBall),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .stepAside),
                        ChallengeCard(challenge: .showUsACompletion, bonusPlay: .passingPlay),
                    ],
                    objectives: Objectives(
                        first: nil,
                        second: ChallengeCard(challenge: .gangUp, bonusPlay: .toughEnough),
                        third: ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .accuratePass)
                    ),
                    discards: [
                        ChallengeCard(challenge: .moveTheBall, bonusPlay: .rawTalent)
                    ]
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run),
                        snapshot: ActionSnapshot(
                            balls: [Ball(id: 38, state: Ball.State.held(playerID: PlayerID(coachID: .home, index: 1)))],
                            players: [
                                Player(id: PlayerID(coachID: .away, index: 6), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 4, armour: nil, skills: [.bomber]), state: .standing(square: sq(7, 5)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .home, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(5, 8)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 8), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: nil, skills: []), state: .standing(square: sq(4, 0)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(2, 0)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(6, 4)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 7), spec: PlayerSpec(move: PlayerSpec.Move.fixed(6), block: 1, pass: 5, armour: nil, skills: [.leap]), state: .standing(square: sq(6, 0)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .home, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(9), block: 1, pass: 4, armour: 5, skills: [.safeHands]), state: .inReserves, canTakeActions: true),
                                Player(id: PlayerID(coachID: .home, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 3, armour: 4, skills: [.handlingSkills]), state: .standing(square: sq(4, 14)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 9), spec: PlayerSpec(move: PlayerSpec.Move.d6, block: 3, pass: nil, armour: 3, skills: [.warMachine]), state: .inReserves, canTakeActions: true),
                                Player(id: PlayerID(coachID: .home, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 2)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(0, 4)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(10, 0)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .home, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 14)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .home, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: 3, skills: [.offensiveSpecialist]), state: .standing(square: sq(4, 5)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(7, 0)), canTakeActions: true),
                                Player(id: PlayerID(coachID: .away, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(9, 0)), canTakeActions: true)
                            ]
                        )
                    ),
                    .runValidSquares(
                        maxDistance: 5,
                        validSquares: ValidMoveSquares(
                            intermediate: [sq(10, 3), sq(6, 3), sq(5, 0), sq(6, 1), sq(5, 3), sq(8, 5), sq(6, 2), sq(10, 2), sq(10, 5), sq(10, 1), sq(5, 1), sq(7, 1), sq(7, 2), sq(9, 5), sq(9, 1), sq(5, 2), sq(7, 3), sq(10, 0), sq(6, 5), sq(8, 2), sq(8, 0), sq(7, 4), sq(8, 1), sq(10, 4), sq(9, 2)],
                            final: [sq(6, 2), sq(8, 0), sq(8, 2), sq(10, 5), sq(8, 1), sq(7, 4), sq(10, 4), sq(10, 1), sq(7, 2), sq(5, 2), sq(5, 3), sq(5, 1), sq(7, 3), sq(9, 5), sq(10, 3), sq(10, 0), sq(6, 3), sq(8, 5), sq(6, 5), sq(5, 0), sq(10, 2), sq(9, 1), sq(6, 1), sq(7, 1), sq(9, 2)]
                        )
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .run),
                        snapshot: ActionSnapshot(
                            balls: [Ball(id: 38, state: Ball.State.held(playerID: PlayerID(coachID: .home, index: 1)))],
                            players: [Player(id: PlayerID(coachID: .away, index: 6), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 4, armour: nil, skills: [.bomber]), state: .standing(square: sq(7, 5)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(5, 8)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 8), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: nil, skills: []), state: .standing(square: sq(4, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(2, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(6, 4)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 7), spec: PlayerSpec(move: PlayerSpec.Move.fixed(6), block: 1, pass: 5, armour: nil, skills: [.leap]), state: .standing(square: sq(6, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(9), block: 1, pass: 4, armour: 5, skills: [.safeHands]), state: .inReserves, canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 3, armour: 4, skills: [.handlingSkills]), state: .standing(square: sq(4, 14)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 9), spec: PlayerSpec(move: PlayerSpec.Move.d6, block: 3, pass: nil, armour: 3, skills: [.warMachine]), state: .inReserves, canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 2)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(0, 4)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(10, 5)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 14)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: 3, skills: [.offensiveSpecialist]), state: .standing(square: sq(4, 5)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(7, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(9, 0)), canTakeActions: true)]
                        )
                    ),
                    .runValidSquares(
                        maxDistance: 5,
                        validSquares: ValidMoveSquares(
                            intermediate: [sq(7, 1), sq(10, 3), sq(5, 3), sq(10, 0), sq(8, 2), sq(10, 2), sq(6, 3), sq(7, 2), sq(9, 0), sq(10, 4), sq(6, 1), sq(6, 5), sq(9, 2), sq(8, 5), sq(9, 5), sq(4, 3), sq(5, 1), sq(10, 1), sq(7, 3), sq(8, 0), sq(8, 1), sq(5, 2), sq(7, 4), sq(4, 1), sq(9, 1), sq(6, 2), sq(5, 0), sq(4, 2)],
                            final: [sq(8, 1), sq(8, 5), sq(8, 2), sq(9, 5), sq(10, 4), sq(10, 3), sq(6, 5), sq(6, 2), sq(9, 1), sq(8, 0), sq(9, 2), sq(5, 3), sq(6, 1), sq(6, 3), sq(5, 1), sq(7, 4), sq(10, 2), sq(5, 2), sq(7, 1), sq(4, 1), sq(7, 3), sq(9, 0), sq(4, 2), sq(10, 1), sq(7, 2), sq(10, 0), sq(4, 3), sq(5, 0)]
                        )
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run),
                        snapshot: ActionSnapshot(
                            balls: [Ball(id: 38, state: Ball.State.held(playerID: PlayerID(coachID: .home, index: 1)))],
                            players: [Player(id: PlayerID(coachID: .away, index: 6), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 4, armour: nil, skills: [.bomber]), state: .standing(square: sq(7, 5)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(5, 8)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 8), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: nil, skills: []), state: .standing(square: sq(4, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(2, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(6, 4)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 7), spec: PlayerSpec(move: PlayerSpec.Move.fixed(6), block: 1, pass: 5, armour: nil, skills: [.leap]), state: .standing(square: sq(6, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 4), spec: PlayerSpec(move: PlayerSpec.Move.fixed(9), block: 1, pass: 4, armour: 5, skills: [.safeHands]), state: .inReserves, canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 3), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 3, armour: 4, skills: [.handlingSkills]), state: .standing(square: sq(4, 14)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 9), spec: PlayerSpec(move: PlayerSpec.Move.d6, block: 3, pass: nil, armour: 3, skills: [.warMachine]), state: .inReserves, canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 2)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 1), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(0, 4)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(10, 5)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 4, armour: 4, skills: []), state: .standing(square: sq(1, 14)), canTakeActions: true), Player(id: PlayerID(coachID: .home, index: 5), spec: PlayerSpec(move: PlayerSpec.Move.fixed(7), block: 1, pass: 5, armour: 3, skills: [.offensiveSpecialist]), state: .standing(square: sq(4, 5)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 2), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(7, 0)), canTakeActions: true), Player(id: PlayerID(coachID: .away, index: 0), spec: PlayerSpec(move: PlayerSpec.Move.fixed(5), block: 1, pass: 5, armour: nil, skills: [.insignificant]), state: .standing(square: sq(9, 5)), canTakeActions: true)]
                        )
                    ),
                    .runValidSquares(
                        maxDistance: 5,
                        validSquares: ValidMoveSquares(
                            intermediate: [sq(6, 2), sq(0, 0), sq(3, 3), sq(7, 1), sq(5, 2), sq(4, 1), sq(7, 4), sq(6, 5), sq(2, 5), sq(3, 0), sq(5, 1), sq(1, 0), sq(0, 5), sq(7, 3), sq(6, 3), sq(6, 1), sq(4, 3), sq(3, 2), sq(2, 0), sq(3, 1), sq(7, 2), sq(1, 5), sq(4, 2), sq(5, 0), sq(5, 3)],
                            final: [sq(2, 0), sq(5, 1), sq(5, 0), sq(4, 1), sq(5, 2), sq(4, 2), sq(7, 1), sq(1, 0), sq(3, 3), sq(5, 3), sq(6, 1), sq(0, 0), sq(3, 0), sq(7, 3), sq(3, 1), sq(3, 2), sq(6, 3), sq(7, 2), sq(6, 2), sq(7, 4), sq(4, 3)]
                        )
                    ),
                    .actionFinished,
                    .choosingObjectiveToClaim(objectiveIndices: [0]),
                    .claimedObjective(objectiveIndex: 0),
                    .eligibleForInspirationBonusPlayFreeAction
                ]
            ),
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .eligibleForInspirationBonusPlayFreeAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 3),
                            square: sq(3, 3),
                            declarations: [
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 2),
                            square: sq(7, 0),
                            declarations: [
                                PromptValidDeclaration(actionID: .run, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [.interference])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 6),
                            square: sq(7, 5),
                            declarations: [
                                PromptValidDeclaration(actionID: .run, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .block, consumesBonusPlays: [])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 9),
                            square: nil,
                            declarations: [
                                PromptValidDeclaration(actionID: .reserves, consumesBonusPlays: [])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 0),
                            square: sq(9, 5),
                            declarations: [
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [.interference])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 7),
                            square: sq(6, 0),
                            declarations: [
                                PromptValidDeclaration(actionID: .run, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [.interference])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 4),
                            square: sq(6, 4),
                            declarations: [
                                PromptValidDeclaration(actionID: .run, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 8),
                            square: sq(4, 0),
                            declarations: [
                                PromptValidDeclaration(actionID: .run, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 1),
                            square: sq(0, 4),
                            declarations: [
                                PromptValidDeclaration(actionID: .run, consumesBonusPlays: []),
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [])
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: PlayerID(coachID: .away, index: 5),
                            square: sq(10, 5),
                            declarations: [
                                PromptValidDeclaration(actionID: .mark, consumesBonusPlays: [.interference])
                            ]
                        )
                    ]
                )
            )
        )

        // Declare mark with interference

        let (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
                    ),
                    consumesBonusPlays: [.interference]
                )
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration),
                    hand: [
                        .open(card: ChallengeCard(challenge: .takeThemDown, bonusPlay: .divingTackle)),
                        .open(card: ChallengeCard(challenge: .getMoving, bonusPlay: .interference))
                    ],
                    active: [
                        ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration)
                    ]
                ),
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .getMoving, bonusPlay: .interference),
                    hand: [
                        .open(card: ChallengeCard(challenge: .takeThemDown, bonusPlay: .divingTackle)),
                    ],
                    active: [
                        ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .getMoving, bonusPlay: .interference)
                    ]
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(9, 5)
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .markActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(9, 5)
                    ),
                    maxDistance: 4,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        .....aaaaaa
                        .....aaaaaa
                        .....aaa..a
                        .....a.a..a
                        .....aa.aa.
                        .....aaaaaa
                        .....aaaaaa
                        ......aaaaa
                        .....aaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        .....a.....
                        .....a.....
                        .....a.....
                        .....aa....
                        ......a....
                        .....aa....
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)
    }
}
