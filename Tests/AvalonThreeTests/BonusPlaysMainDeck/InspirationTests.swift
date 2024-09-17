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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeRunAction() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 2),
                        actionID: .run
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 2),
                        actionID: .run
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 2),
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
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(6, 4),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(7, 5),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(8, 5),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(9, 6),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(10, 7),
                    reason: .run
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeMarkAction() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 6),
                        actionID: .mark
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 6),
                        actionID: .mark
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 6),
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
                    playerID: PlayerID(coachID: .away, index: 6),
                    square: sq(5, 5),
                    reason: .mark
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 6),
                    square: sq(6, 6),
                    reason: .mark
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free pass

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 2),
                        actionID: .pass
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 2),
                        actionID: .pass
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 2),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 3),
                            targetSquare: sq(4, 8),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(1, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(1, 7)]
                        ),
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 6),
                            targetSquare: sq(4, 4),
                            distance: .handoff,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 5),
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
                    target: PlayerID(coachID: CoachID.away, index: 5)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 2),
                .changedPassResult(die: .d6, modified: 1, modifications: [.targetPlayerMarked]),
                .playerFumbledBall(playerID: PlayerID(coachID: .away, index: 2)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .west),
                .ballBounced(ballID: ballID, to: sq(4, 4)),
                .playerCaughtBouncingBall(
                    playerID: PlayerID(coachID: .away, index: 6),
                    ballID: ballID
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free hurl teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 6),
                        actionID: .hurlTeammate
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 6),
                        actionID: .hurlTeammate
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: PlayerID(coachID: .away, index: 6),
                    validTeammates: [
                        PlayerID(coachID: .away, index: 2),
                    ]
                )
            )
        )

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: PlayerID(coachID: .away, index: 2)
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
                    playerID: PlayerID(coachID: .away, index: 6),
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
                .rolledForHurlTeammate(die: .d6, unmodified: 4),
                .changedHurlTeammateResult(die: .d6, modified: 3, modifications: [.longDistance, .obstructed]),
                .playerHurledTeammate(
                    playerID: PlayerID(coachID: .away, index: 6),
                    teammateID: PlayerID(coachID: .away, index: 2),
                    square: sq(10, 10)
                ),
                .hurledTeammateCrashed(playerID: PlayerID(coachID: CoachID.away, index: 2)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: Direction.southEast),
                .changedDirection(direction: Direction.south),
                .ballBounced(ballID: ballID, to: sq(10, 11)),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeFoulAction() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free foul

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .foul
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .foul
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .foulActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 3),
                    validTargets: [
                        PlayerID(coachID: .home, index: 4),
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
                    target: PlayerID(coachID: .home, index: 4)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForFoul(result: .gotThem),
                .playerFouled(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(3, 9)
                ),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 4), reason: .fouled),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeBlockAction() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free block

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .block
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .block
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 5),
                    validTargets: [
                        PlayerID(coachID: .home, index: 5),
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
                    target: PlayerID(coachID: .home, index: 5)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.shove]),
                .selectedBlockDieResult(coachID: .away, result: .shove),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(7, 7)
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 5),
                    square: sq(6, 8),
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionEligibleForFollowUp(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                .declinedFollowUp(playerID: PlayerID(coachID: .away, index: 5)),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .mark), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeSidestepAction() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .sidestep
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .sidestep
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(9, 7),
                    reason: .sidestep
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .foul), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeStandUpAction() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free stand up

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 4),
                        actionID: .standUp
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 4),
                        actionID: .standUp
                    ),
                    isFree: true
                ),
                .playerStoodUp(playerID: PlayerID(coachID: .away, index: 4)),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func takeFreeReservesAction() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(0, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 2),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 3),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 4),
                            spec: .halfling_catcher,
                            state: .prone(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 5),
                            spec: .halfling_hefty,
                            state: .standing(square: sq(8, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 6),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(4, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .human_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .human_passer,
                            state: .standing(square: sq(4, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 4),
                            spec: .human_catcher,
                            state: .prone(square: sq(3, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 5),
                            spec: .human_blitzer,
                            state: .standing(square: sq(7, 7)),
                            canTakeActions: true
                        ),
                    ],
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
                            state: .held(playerID: PlayerID(coachID: .away, index: 2))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 5),
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
                        playerID: PlayerID(coachID: .away, index: 5),
                        actionID: .mark
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 5),
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
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(8, 6),
                    reason: .mark
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
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
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
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
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(4, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForInspirationBonusPlayFreeAction(validDeclarations: [
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 0), actionID: .reserves), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 1), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 2), actionID: .pass), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 3), actionID: .foul), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 4), actionID: .standUp), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .block), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .run), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .mark), consumesBonusPlays: []),
                    ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .away, index: 6), actionID: .hurlTeammate), consumesBonusPlays: []),
                ])
            )
        )

        // MARK: - Declare free reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useInspirationBonusPlayFreeAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .reserves
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .reserves
                    ),
                    isFree: true
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .away, index: 0),
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
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 0),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .inspiration)
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 0), actionID: .sidestep), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 1), actionID: .reserves), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 2), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .run), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 3), actionID: .mark), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 4), actionID: .standUp), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .block), consumesBonusPlays: []),
                        ValidDeclaration(declaration: ActionDeclaration(playerID: PlayerID(coachID: .home, index: 5), actionID: .sidestep), consumesBonusPlays: []),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }
}
