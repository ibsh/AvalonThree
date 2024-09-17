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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
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
                    playerID: PlayerID(coachID: .away, index: 0),
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

        (latestEvents, latestPayload) = try game.process(
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
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(10, 9),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(9, 8),
                    reason: .run
                ),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    PlayerID(coachID: .home, index: 0),
                    PlayerID(coachID: .home, index: 1),
                    PlayerID(coachID: .home, index: 2),
                ])
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 1),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 1),
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

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 1),
                    square: sq(7, 14),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves)
                ),
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 2),
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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
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
                    playerID: PlayerID(coachID: .away, index: 0),
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

        (latestEvents, latestPayload) = try game.process(
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
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(10, 9),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(9, 8),
                    reason: .run
                ),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    PlayerID(coachID: .home, index: 0),
                    PlayerID(coachID: .home, index: 1),
                    PlayerID(coachID: .home, index: 2),
                ])
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineReservesBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 2),
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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
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
                    playerID: PlayerID(coachID: .away, index: 0),
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

        (latestEvents, latestPayload) = try game.process(
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
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(10, 9),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(9, 8),
                    reason: .run
                ),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declareEmergencyReservesAction(validPlayers: [
                    PlayerID(coachID: .home, index: 0),
                    PlayerID(coachID: .home, index: 1),
                    PlayerID(coachID: .home, index: 2),
                    PlayerID(coachID: .home, index: 3),
                ])
            )
        )

        // MARK: - Declare emergency reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: PlayerID(coachID: .home, index: 3)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 3),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 3),
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

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 3),
                    square: sq(7, 14),
                    reason: .reserves
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    PlayerID(coachID: .home, index: 0),
                    PlayerID(coachID: .home, index: 1),
                    PlayerID(coachID: .home, index: 2),
                ])
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves)
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 1),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 1),
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

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(1, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 1),
                    square: sq(1, 14),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves)
                ),
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 3),
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

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 3),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
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
                    playerID: PlayerID(coachID: .away, index: 0),
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

        (latestEvents, latestPayload) = try game.process(
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
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(10, 9),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(9, 8),
                    reason: .run
                ),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declareEmergencyReservesAction(validPlayers: [
                    PlayerID(coachID: .home, index: 0),
                    PlayerID(coachID: .home, index: 1),
                    PlayerID(coachID: .home, index: 2),
                    PlayerID(coachID: .home, index: 3),
                ])
            )
        )

        // MARK: - Declare emergency reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: PlayerID(coachID: .home, index: 3)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 3),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 3),
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

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 3),
                    square: sq(7, 14),
                    reason: .reserves
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForReservesBonusPlayReservesAction(validPlayers: [
                    PlayerID(coachID: .home, index: 0),
                    PlayerID(coachID: .home, index: 1),
                    PlayerID(coachID: .home, index: 2),
                ])
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineReservesBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .finalTurnBegan,
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 3),
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
