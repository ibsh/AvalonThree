//
//  ReservesTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct ReservesTests {

    @Test func usedWithoutEmergencyReserves() async throws {

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
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(10, 10)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        .....aaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 10),
                    to: sq(10, 9),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 9),
                    to: sq(9, 8),
                    direction: .northWest,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    pl(.home, 0),
                    pl(.home, 1),
                    pl(.home, 2),
                ])
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
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
                        bonusPlay: .reserves
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
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
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 1),
                    to: sq(7, 14)
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .reserves
                    )
                ),
                .updatedDiscards(
                    top: .reserves,
                    count: 1
                ),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func declinedWithoutEmergencyReserves() async throws {

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
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(10, 10)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        .....aaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 10),
                    to: sq(10, 9),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 9),
                    to: sq(9, 8),
                    direction: .northWest,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    pl(.home, 0),
                    pl(.home, 1),
                    pl(.home, 2),
                ])
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineReservesBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func usedWithEmergencyReserves() async throws {

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
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(10, 10)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        .....aaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 10),
                    to: sq(10, 9),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 9),
                    to: sq(9, 8),
                    direction: .northWest,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declareEmergencyReservesAction(validPlayers: [
                    pl(.home, 0),
                    pl(.home, 1),
                    pl(.home, 2),
                    pl(.home, 3),
                ])
            )
        )

        // MARK: - Declare emergency reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: pl(.home, 3)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 3),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: pl(.home, 3),
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
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 3),
                    to: sq(7, 14)
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    pl(.home, 0),
                    pl(.home, 1),
                    pl(.home, 2),
                ])
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
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
                        bonusPlay: .reserves
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
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
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaa.aaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(1, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 1),
                    to: sq(1, 14)
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .reserves
                    )
                ),
                .updatedDiscards(
                    top: .reserves,
                    count: 1
                ),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 3),
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

    @Test func declinedWithEmergencyReserves() async throws {

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
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(10, 10)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        .....aaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 10),
                    to: sq(10, 9),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(10, 9),
                    to: sq(9, 8),
                    direction: .northWest,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declareEmergencyReservesAction(validPlayers: [
                    pl(.home, 0),
                    pl(.home, 1),
                    pl(.home, 2),
                    pl(.home, 3),
                ])
            )
        )

        // MARK: - Declare emergency reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: pl(.home, 3)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 3),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: pl(.home, 3),
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
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 3),
                    to: sq(7, 14)
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    pl(.home, 0),
                    pl(.home, 1),
                    pl(.home, 2),
                ])
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineReservesBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 3),
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
}
