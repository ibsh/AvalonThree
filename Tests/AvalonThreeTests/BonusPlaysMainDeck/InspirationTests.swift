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

        // MARK: - Init

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineInspirationBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == [
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeRunAction() async throws {

        // MARK: - Init

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .run
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .run
                    ),
                    isFree: true,
                    playerSquare: sq(5, 4)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 2),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..a.aaa..a
                        aaaaaaaaaaa
                        ...aaa...aa
                        ...aaa...aa
                        ...a.a...aa
                        aaa.a...aaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..a.aaa..a
                        aaaaaaaaaaa
                        ...aaa...aa
                        ...aaa...aa
                        ...a.a.....
                        ..a.a......
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

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(6, 4),
                    sq(7, 5),
                    sq(8, 5),
                    sq(9, 6),
                    sq(10, 7),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(5, 4),
                    to: sq(6, 4),
                    direction: .east,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(6, 4),
                    to: sq(7, 5),
                    direction: .southEast,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(7, 5),
                    to: sq(8, 5),
                    direction: .east,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(8, 5),
                    to: sq(9, 6),
                    direction: .southEast,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(9, 6),
                    to: sq(10, 7),
                    direction: .southEast,
                    reason: .run
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeMarkAction() async throws {

        // MARK: - Init

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 6),
                        actionID: .mark
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 6),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(4, 4)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 6),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ..aaaaa....
                        ...aaaa....
                        ...aa.a....
                        ..aaaaa....
                        ..aaaaa....
                        ...........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ..a...a....
                        ...........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(5, 5),
                    sq(6, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 6),
                    ballID: nil,
                    from: sq(4, 4),
                    to: sq(5, 5),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.away, 6),
                    ballID: nil,
                    from: sq(5, 5),
                    to: sq(6, 6),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreePassAction() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free pass

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .pass
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .pass
                    ),
                    isFree: true,
                    playerSquare: sq(5, 4)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 2),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 3),
                            targetSquare: sq(4, 8),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(1, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(1, 7)]
                        ),
                        PassTarget(
                            targetPlayerID: pl(.away, 6),
                            targetSquare: sq(4, 4),
                            distance: .handoff,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                        PassTarget(
                            targetPlayerID: pl(.away, 5),
                            targetSquare: sq(8, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(7, 7)]
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [2]
        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(CoachID.away, 5)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 2
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 2,
                    modified: 1,
                    modifications: [.targetPlayerMarked]
                ),
                .playerFumbledBall(
                    playerID: pl(.away, 2),
                    in: sq(5, 4),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, in: sq(5, 4)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .west
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(5, 4),
                    to: sq(4, 4),
                    direction: .west
                ),
                .playerCaughtBouncingBall(
                    playerID: pl(.away, 6),
                    in: sq(4, 4),
                    ballID: 123
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeHurlTeammateAction() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free hurl teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 6),
                        actionID: .hurlTeammate
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 6),
                        actionID: .hurlTeammate
                    ),
                    isFree: true,
                    playerSquare: sq(4, 4)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: pl(.away, 6),
                    validTeammates: [
                        pl(.away, 2),
                    ]
                )
            )
        )

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: pl(.away, 2)
                )
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 6),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .long, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .short, obstructingSquares: [sq(2, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(2, 3), sq(2, 4), sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: [sq(2, 4), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .short, obstructingSquares: [sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .short, obstructingSquares: [sq(1, 3), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: [sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .short, obstructingSquares: [sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .short, obstructingSquares: [sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .long, obstructingSquares: [sq(4, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: [sq(4, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: [sq(4, 11)]),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: [sq(4, 11)]),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: [sq(4, 11)]),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: [sq(6, 10)]),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: [sq(6, 10)]),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: [sq(6, 10)]),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: [sq(6, 10)]),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: [sq(6, 10)]),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .short, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .short, obstructingSquares: [sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 1), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 2), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 3), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4), sq(8, 3), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(9, 10)]),
                    ]
                )
            )
        )

        // MARK: - Specify target

        d6Randomizer.nextResults = [4]
        directionRandomizer.nextResults = [.southEast]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(
                    targetSquare: sq(10, 10)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 4
                ),
                .changedHurlTeammateResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 6),
                    teammateID: pl(.away, 2),
                    ballID: 123,
                    from: sq(4, 4),
                    to: sq(10, 10),
                    angle: 135
                ),
                .hurledTeammateCrashed(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    in: sq(10, 10)
                ),
                .ballCameLoose(
                    ballID: 123,
                    in: sq(10, 10)
                ),
                .rolledForDirection(
                    coachID: .away,
                    direction: .southEast
                ),
                .changedDirection(
                    from: .southEast,
                    to: .south
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(10, 10),
                    to: sq(10, 11),
                    direction: .south
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeFoulAction() async throws {

        // MARK: - Init

        let ballID = 123

        let foulDieRandomizer = FoulDieRandomizerDouble()

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free foul

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .foul
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .foul
                    ),
                    isFree: true,
                    playerSquare: sq(4, 8)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .foulActionSpecifyTarget(
                    playerID: pl(.away, 3),
                    validTargets: [
                        pl(.home, 4),
                    ]
                )
            )
        )

        // MARK: - Specify foul

        foulDieRandomizer.nextResults = [.gotThem]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .foulActionSpecifyTarget(
                    target: pl(.home, 4)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForFoul(
                    coachID: .away,
                    result: .gotThem
                ),
                .playerFouled(
                    playerID: pl(.away, 3),
                    from: sq(4, 8),
                    to: sq(3, 9),
                    direction: .southWest,
                    targetPlayerID: pl(.home, 4)
                ),
                .playerInjured(
                    playerID: pl(.home, 4),
                    in: sq(3, 9),
                    reason: .fouled
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeBlockAction() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free block

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .block
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .block
                    ),
                    isFree: true,
                    playerSquare: sq(8, 6)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 5),
                    validTargets: [
                        pl(.home, 5),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(
                    target: pl(.home, 5)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .away,
                    results: [.shove]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .shove
                ),
                .playerBlocked(
                    playerID: pl(.away, 5),
                    from: sq(8, 6),
                    to: sq(7, 7),
                    direction: .southWest,
                    targetPlayerID: pl(.home, 5)
                ),
                .playerMoved(
                    playerID: pl(.home, 5),
                    ballID: nil,
                    from: sq(7, 7),
                    to: sq(6, 8),
                    direction: .southWest,
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionEligibleForFollowUp(
                    playerID: pl(.away, 5),
                    square: sq(7, 7)
                )
            )
        )

        // MARK: - Decline followup

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineFollowUp
            )
        )

        #expect(
            latestEvents == [
                .declinedFollowUp(
                    playerID: pl(.away, 5),
                    in: sq(8, 6)
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .mark), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeSidestepAction() async throws {

        // MARK: - Init

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .sidestep
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .sidestep
                    ),
                    isFree: true,
                    playerSquare: sq(8, 6)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: [],
                        final: [sq(7, 5), sq(8, 5), sq(9, 5), sq(9, 6), sq(9, 7)]
                    )
                )
            )
        )

        // MARK: - Specify sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSpecifySquare(square: sq(9, 7))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 6),
                    to: sq(9, 7),
                    direction: .southEast,
                    reason: .sidestep
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .foul), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeStandUpAction() async throws {

        // MARK: - Init

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free stand up

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 4),
                        actionID: .standUp
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 4),
                        actionID: .standUp
                    ),
                    isFree: true,
                    playerSquare: sq(7, 6)
                ),
                .playerStoodUp(
                    playerID: pl(.away, 4),
                    in: sq(7, 6)
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeReservesAction() async throws {

        // MARK: - Init

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(0, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 1),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        a..........
                        a..........
                        aaa........
                        aaa........
                        a.a........
                        ...........
                        ...........
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
                        ...........
                        ...........
                        aaa........
                        a.a........
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(1, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 5),
                    to: sq(1, 6),
                    direction: .southEast,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare mark

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(8, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 5),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ......aa..a
                        ......aa..a
                        ......aaaaa
                        ......a.aaa
                        ......a.aaa
                        ...........
                        ...........
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
                        ...........
                        ...........
                        ......a.a..
                        ........a..
                        ...........
                        ...........
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

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 5),
                    to: sq(8, 6),
                    direction: .south,
                    reason: .mark
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa...a.
                        ...aaa...a.
                        aaa.a...aa.
                        a..........
                        a..........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa...
                        a..a..aa...
                        aaaaaaaaaa.
                        ...aaa...a.
                        ...aaa.....
                        ...aaa.....
                        aaa.a......
                        a..........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(4, 7),
                        sq(4, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(4, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.away, 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .reserves
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
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

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(6, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 0),
                    to: sq(6, 0)
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .inspiration
                    )
                ),
                .updatedDiscards(
                    top: .inspiration,
                    count: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }
}
