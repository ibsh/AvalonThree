//
//  InterventionTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct InterventionTests {

    @Test func ineligibleWhenTooFarAway() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(0, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ..aaaaaaaaa
                        ..aaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ..aaaaaaaaa
                        ..aaaaaaaaa
                        .aaaaaaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func onePlayerEligible() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(0, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        .aaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        .aaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ..aaaaaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(1, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 0),
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
                        a..a.......
                        a..a.......
                        aaaa.......
                        aaaa.......
                        aaaa.......
                        """),
                        final: squares("""
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
                        ...a.......
                        ...a.......
                        ...a.......
                        """)
                    )
                )
            )
        )

        // MARK: - Try marking the wrong player

        #expect(throws: GameError("Invalid final square")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .home,
                    message: .markActionSpecifySquares(
                        squares: [
                            sq(0, 11),
                            sq(0, 10),
                        ]
                    )
                )
            )
        }

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(2, 13),
                    sq(3, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(1, 12),
                    to: sq(2, 13),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 13),
                    to: sq(3, 14),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func twoPlayersEligible() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaa....a
                        ...aaa...aa
                        ...aaa...aa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaa.....
                        ...aaa.....
                        ...aaa.....
                        ..aaaaa....
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 1))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(7, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 1),
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
                        .....aaa...
                        .....aaa...
                        .....aaaaa.
                        .....aaaaa.
                        .....aaaaa.
                        """),
                        final: squares("""
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
                        .....a.....
                        .....a.....
                        .....a.....
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(6, 13),
                    sq(5, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(7, 12),
                    to: sq(6, 13),
                    direction: .southWest,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(6, 13),
                    to: sq(5, 14),
                    direction: .southWest,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
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

    @Test func eligibleWithInterference() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(8, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .interference),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaa...a
                        ...aaaa...a
                        ...aaaa...a
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaa....
                        ...aaaa....
                        ...aaaa....
                        ..aaaaaa...
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(validDeclarations: [
                    ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.home, 0),
                            actionID: .mark
                        ),
                        consumesBonusPlays: []
                    ),
                    ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.home, 1),
                            actionID: .mark
                        ),
                        consumesBonusPlays: [.interference]
                    ),
                ])
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(
                    playerID: pl(.home, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .breakSomeBones,
                                bonusPlay: .interference
                            )
                        )
                    ]
                ),
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .interference
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(8, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 1),
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
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        .....aaaaaa
                        ....aaaaaaa
                        """),
                        final: squares("""
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
                        ....aa.....
                        .....a.....
                        ....aa.....
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(7, 12),
                    sq(6, 12),
                    sq(5, 12),
                    sq(4, 12),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(8, 12),
                    to: sq(7, 12),
                    direction: .west,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(7, 12),
                    to: sq(6, 12),
                    direction: .west,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(6, 12),
                    to: sq(5, 12),
                    direction: .west,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(5, 12),
                    to: sq(4, 12),
                    direction: .west,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .interference
                    )
                ),
                .updatedDiscards(
                    top: .interference,
                    count: 2
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

    @Test func canLeadToFreeBlockWithFrenzy() async throws {

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
                        coinFlipWinnerTeamID: .dwarf,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(0, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .dwarf_trollslayer,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        .aaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        .aaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ..aaaaaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(1, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 0),
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
                        a..a.......
                        a..a.......
                        aaaa.......
                        aaaa.......
                        aaaa.......
                        """),
                        final: squares("""
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
                        ...a.......
                        ...a.......
                        ...a.......
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(2, 13),
                    sq(3, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(1, 12),
                    to: sq(2, 13),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 13),
                    to: sq(3, 14),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForFrenziedSkillBlockAction(
                    playerID: pl(.home, 0)
                )
            )
        )

        // MARK: - Take free block

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useFrenziedSkillBlockAction
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .block
                    ),
                    isFree: true,
                    playerSquare: sq(3, 14)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.home, 0),
                    validTargets: [
                        pl(.away, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionSpecifyTarget(target: pl(.away, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .home,
                    results: [.shove]
                ),
                .selectedBlockDieResult(
                    coachID: .home,
                    result: .shove
                ),
                .playerBlocked(
                    playerID: pl(.home, 0),
                    from: sq(3, 14),
                    to: sq(4, 13),
                    direction: .northEast,
                    targetPlayerID: pl(.away, 0)
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 13),
                    to: sq(5, 12),
                    direction: .northEast,
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionEligibleForFollowUp(
                    playerID: pl(.home, 0),
                    square: sq(4, 13)
                )
            )
        )

        // MARK: - Follow up

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionUseFollowUp
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(3, 14),
                    to: sq(4, 13),
                    direction: .northEast,
                    reason: .followUp
                )
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func canLeadToFreeBlockWithDivingTackle() async throws {

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
                        coinFlipWinnerTeamID: .elf,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(0, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .elf_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .divingTackle),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        .aaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        .aaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ..aaaaaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .breakSomeBones,
                                bonusPlay: .divingTackle
                            )
                        )
                    ]
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(1, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 0),
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
                        a..a.......
                        a..a.......
                        aaaa.......
                        aaaa.......
                        aaaa.......
                        """),
                        final: squares("""
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
                        ...a.......
                        ...a.......
                        ...a.......
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(2, 13),
                    sq(3, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(1, 12),
                    to: sq(2, 13),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 13),
                    to: sq(3, 14),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForDivingTackleBonusPlayBlockAction(
                    playerID: pl(.home, 0)
                )
            )
        )

        // MARK: - Take free block

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useDivingTackleBonusPlayBlockAction
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .divingTackle
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .block
                    ),
                    isFree: true,
                    playerSquare: sq(3, 14)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.home, 0),
                    validTargets: [
                        pl(.away, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionSpecifyTarget(target: pl(.away, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .home,
                    results: [.shove]
                ),
                .selectedBlockDieResult(
                    coachID: .home,
                    result: .shove
                ),
                .playerBlocked(
                    playerID: pl(.home, 0),
                    from: sq(3, 14),
                    to: sq(4, 13),
                    direction: .northEast,
                    targetPlayerID: pl(.away, 0)
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 13),
                    to: sq(5, 12),
                    direction: .northEast,
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionEligibleForFollowUp(
                    playerID: pl(.home, 0),
                    square: sq(4, 13)
                )
            )
        )

        // MARK: - Follow up

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionUseFollowUp
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(3, 14),
                    to: sq(4, 13),
                    direction: .northEast,
                    reason: .followUp
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(4, 13),
                    reason: PlayerFallDownReason
                        .divingTackle
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .divingTackle
                    )
                ),
                .updatedDiscards(
                    top: .divingTackle,
                    count: 2
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
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .foul
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func cannotPreventOpponentFromScoringTouchdownWhenDeclined() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ..aaaaaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                        sq(4, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 13),
                    to: sq(4, 14),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineInterventionBonusPlayMarkAction
            )
        )

        #expect(
            latestEvents == [
                .playerScoredTouchdown(
                    playerID: pl(.away, 0),
                    in: sq(4, 14),
                    ballID: 123
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 4,
                    total: 4
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
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func canPreventOpponentFromScoringTouchdownWhenUsed() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ..aaaaaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                        sq(4, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 13),
                    to: sq(4, 14),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(1, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 0),
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
                        a..a.......
                        a..a.......
                        aaaa.......
                        aaaa.......
                        aaaa.......
                        """),
                        final: squares("""
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
                        ...a.......
                        ...a.......
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(2, 13),
                    sq(3, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(1, 12),
                    to: sq(2, 13),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 13),
                    to: sq(3, 14),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
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

    @Test func cannotPreventOpponentFromEarningGoDeepWhenDeclined() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 13)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .goDeep, bonusPlay: .absoluteCarnage)
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaa.a
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaa.a
                        ..aaaaaaaa.
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineInterventionBonusPlayMarkAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )
    }

    @Test func canPreventOpponentFromEarningGoDeepWhenUsed() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 13)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .goDeep, bonusPlay: .absoluteCarnage)
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaa.a
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaa.a
                        ..aaaaaaaa.
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(1, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 0),
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
                        a..a.......
                        a..a.......
                        aaaa.......
                        aaaa.......
                        aaaa.......
                        """),
                        final: squares("""
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
                        ...a.......
                        ...a.......
                        ...a.......
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(2, 13),
                    sq(3, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(1, 12),
                    to: sq(2, 13),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 13),
                    to: sq(3, 14),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func cannotEarnObjectivesOutOfTurn() async throws {

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
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 14)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(8, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .intervention),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(challenge: .tieThemUp, bonusPlay: .absoluteCarnage)
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
                    playerSquare: sq(4, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaa...aa
                        aaaaaa...aa
                        aaaaaa...aa
                        a..aaaaa..a
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        aaaa.aaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaa...aa
                        aaaaaa...aa
                        aaaaaa.....
                        a..aaaaa...
                        ...aaaaa..a
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ..aa.aaaaaa
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
                        sq(4, 9),
                        sq(4, 10),
                        sq(4, 11),
                        sq(4, 12),
                        sq(4, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 8),
                    to: sq(4, 9),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 9),
                    to: sq(4, 10),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 10),
                    to: sq(4, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 11),
                    to: sq(4, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 12),
                    to: sq(4, 13),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForInterventionBonusPlayMarkAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useInterventionBonusPlayMarkAction(playerID: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
                    ),
                    isFree: true,
                    playerSquare: sq(1, 12)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .markActionSpecifySquares(
                    playerID: pl(.home, 0),
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
                        a..a.......
                        a..a.......
                        aaaa.......
                        aaaa.......
                        aaaa.......
                        """),
                        final: squares("""
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
                        ...a.......
                        ...a.......
                        ...a.......
                        """)
                    )
                )
            )
        )

        // MARK: - Try marking the wrong player

        #expect(throws: GameError("Invalid final square")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .home,
                    message: .markActionSpecifySquares(
                        squares: [
                            sq(0, 11),
                            sq(0, 10),
                        ]
                    )
                )
            )
        }

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSpecifySquares(squares: [
                    sq(2, 13),
                    sq(3, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(1, 12),
                    to: sq(2, 13),
                    direction: .southEast,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 13),
                    to: sq(3, 14),
                    direction: .southEast,
                    reason: .mark
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .intervention
                    )
                ),
                .updatedDiscards(
                    top: .intervention,
                    count: 1
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
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
}
