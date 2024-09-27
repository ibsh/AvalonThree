//
//  RushTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Testing
@testable import AvalonThree

struct RushTests {

    @Test func canMoveAdjacentToPlayersAsLongAsTheRunEndsThere() async throws {

        // MARK: - Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .woodElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .woodElf_wardancer,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [],
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

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        .O.aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        .Oaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaa.
                        aaaaaaaaaa.
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
                    sq(3, 6),
                    sq(2, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 5),
                    to: sq(3, 6),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func cannotMoveAdjacentToPlayersAndThenAway() async throws {

        // MARK: - Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .woodElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .woodElf_wardancer,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [],
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

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        ..aaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        #expect(throws: GameError("Invalid intermediate square")) {
            (latestEvents, latestPayload) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(squares: [
                        sq(2, 5),
                        sq(3, 6),
                    ])
                )
            )
        }
    }

    @Test func cannotMoveThroughPlayers() async throws {

        // MARK: - Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .woodElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .woodElf_wardancer,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [],
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

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        ..aaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        #expect(throws: GameError("Invalid intermediate square")) {
            (latestEvents, latestPayload) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(squares: [
                        sq(2, 5),
                        sq(1, 5),
                        sq(0, 6),
                        sq(0, 7),
                    ])
                )
            )
        }
    }

    @Test func testTheValidSquareGeneration() async throws {

        // MARK: - Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .woodElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .woodElf_wardancer,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 8)),
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
                    balls: [],
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

        // MARK: - Declare run

        let (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..a...a..a
                        a..a.O.a..a
                        aaaa...aaaa
                        aaaaaaaaaaa
                        aaaaa...a..
                        aaaaa.O.a.O
                        aaaaa...a..
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        aaaaaaaaa..
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa..a
                        a..aa.aa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaa.aaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        """)
                    )
                )
            )
        )
    }
}
