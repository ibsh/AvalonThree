//
//  ComboPlayTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct ComboPlayTests {

    @Test func eligibleForRunAfterHandoff() async throws {

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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

        // MARK: - Declare handoff

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(3, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .handoff,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify handoff

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .playerHandedOffBall(
                    playerID: pl(.away, 0),
                    from: sq(3, 5),
                    to: sq(4, 5),
                    direction: .east,
                    ballID: 123
                ),
                .playerCaughtHandoff(
                    playerID: pl(.away, 1),
                    in: sq(4, 5),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForComboPlayBonusPlayFreeAction(
                    validDeclaration: ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 1),
                            actionID: .run
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useComboPlayBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .run
                    ),
                    isFree: true,
                    playerSquare: sq(4, 5)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 1),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aa.....a
                        aaa.a...aaa
                        aaaaa...aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aa......
                        aaa.a...aa.
                        aaaaa...aa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
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
                        sq(4, 6),
                        sq(4, 7),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    from: sq(4, 5),
                    to: sq(4, 6),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    )
                ),
                .updatedDiscards(
                    top: .comboPlay,
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func eligibleForRunAfterPass() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(2, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 4),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(2, 5),
                    to: sq(4, 5),
                    angle: 90,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(4, 5),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForComboPlayBonusPlayFreeAction(
                    validDeclaration: ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 1),
                            actionID: .run
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useComboPlayBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .run
                    ),
                    isFree: true,
                    playerSquare: sq(4, 5)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 1),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aa.....a
                        aa.aa...aaa
                        aaaaa...aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aa......
                        aa.aa...aa.
                        aaaaa...aa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
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
                        sq(4, 6),
                        sq(4, 7),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    from: sq(4, 5),
                    to: sq(4, 6),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    from: sq(4, 6),
                    to: sq(4, 7),
                    direction: .south,
                    reason: .run
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    )
                ),
                .updatedDiscards(
                    top: .comboPlay,
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func eligibleForSidestepAfterHandoff() async throws {

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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

        // MARK: - Declare handoff

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(3, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .handoff,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify handoff

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .playerHandedOffBall(
                    playerID: pl(.away, 0),
                    from: sq(3, 5),
                    to: sq(4, 5),
                    direction: .east,
                    ballID: 123
                ),
                .playerCaughtHandoff(
                    playerID: pl(.away, 1),
                    in: sq(4, 5),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForComboPlayBonusPlayFreeAction(
                    validDeclaration: ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 1),
                            actionID: .sidestep
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useComboPlayBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .sidestep
                    ),
                    isFree: true,
                    playerSquare: sq(4, 5)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.away, 1),
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
                        ...a.......
                        ...........
                        ...a.......
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

        // MARK: - Specify sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSpecifySquare(square: sq(3, 4))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    from: sq(4, 5),
                    to: sq(3, 4),
                    direction: .northWest,
                    reason: .sidestep
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    )
                ),
                .updatedDiscards(
                    top: .comboPlay,
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .mark
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func eligibleForSidestepAfterPass() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(2, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(5, 5)]
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 5),
                .changedPassResult(
                    die: .d6,
                    unmodified: 5,
                    modified: 4,
                    modifications: [.targetPlayerMarked]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(2, 5),
                    to: sq(4, 5),
                    angle: 90,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(4, 5),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForComboPlayBonusPlayFreeAction(
                    validDeclaration: ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 1),
                            actionID: .sidestep
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useComboPlayBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    ),
                    hand: []
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .sidestep
                    ),
                    isFree: true,
                    playerSquare: sq(4, 5)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.away, 1),
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
                        ...a.......
                        ...a.......
                        ...a.......
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

        // MARK: - Specify sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSpecifySquare(square: sq(3, 4))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    from: sq(4, 5),
                    to: sq(3, 4),
                    direction: .northWest,
                    reason: .sidestep
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .comboPlay
                    )
                ),
                .updatedDiscards(
                    top: .comboPlay,
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .mark
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedAfterHandoff() async throws {

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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

        // MARK: - Declare handoff

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(3, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .handoff,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify handoff

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .playerHandedOffBall(
                    playerID: pl(.away, 0),
                    from: sq(3, 5),
                    to: sq(4, 5),
                    direction: .east,
                    ballID: 123
                ),
                .playerCaughtHandoff(
                    playerID: pl(.away, 1),
                    in: sq(4, 5),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForComboPlayBonusPlayFreeAction(
                    validDeclaration: ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 1),
                            actionID: .run
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineComboPlayBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .mark
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedAfterPass() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(2, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 4),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(2, 5),
                    to: sq(4, 5),
                    angle: 90,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(4, 5),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForComboPlayBonusPlayFreeAction(
                    validDeclaration: ValidDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 1),
                            actionID: .run
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineComboPlayBonusPlayFreeAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func ineligibleAfterFailedPass() async throws {

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
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .comboPlay)
                    ],
                    coinFlipWinnerHand: [],
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
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
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
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(2, 5)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(4, 5),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [1]
        directionRandomizer.nextResults = [.east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 1),
                .playerFumbledBall(
                    playerID: pl(.away, 0),
                    in: sq(2, 5),
                    ballID: 123
                ), .ballCameLoose(ballID: 123, in: sq(2, 5)),
                .rolledForDirection(coachID: .away, direction: .east),
                .ballBounced(
                    ballID: 123,
                    from: sq(2, 5),
                    to: sq(3, 5),
                    direction: .east
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
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
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
