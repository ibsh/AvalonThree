//
//  BlockingPlayTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct BlockingPlayTests {

    @Test func availableOnDeclarationOfRun() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .orc
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 7)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
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
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionEligibleForBlockingPlayBonusPlay(
                    playerID: PlayerID(coachID: .away, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .blockingPlay),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaa......
                        aaaaa......
                        aaaaa......
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaaaaa...
                        aaaaaa.....
                        aaaaaaaa...
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
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
                        sq(3, 7),
                        sq(4, 7),
                        sq(5, 7),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(3, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 7),
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
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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

    @Test func notAppliedIfDeclined() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .orc
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 7)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
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
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionEligibleForBlockingPlayBonusPlay(
                    playerID: PlayerID(coachID: .away, index: 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionDeclineBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaa......
                        aaaaa......
                        aaaaa......
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaa......
                        aaaaa......
                        aaaaa......
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        #expect(throws: GameError("Invalid final square")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(
                        squares: [
                            sq(3, 7),
                            sq(4, 7),
                            sq(5, 7),
                        ]
                    )
                )
            )
        }
    }

    @Test func noLongerAppliedToSubsequentTurn() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .orc
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 7)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        )
                    ],
                    deck: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
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
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare first run

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
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionEligibleForBlockingPlayBonusPlay(
                    playerID: PlayerID(coachID: .away, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .blockingPlay),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaa......
                        aaaaa......
                        aaaaa......
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaaaaa...
                        aaaaaa.....
                        aaaaaaaa...
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify first run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(3, 7),
                        sq(4, 7),
                        sq(5, 7),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(3, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(4, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 7),
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
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare second run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
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
                    playerID: PlayerID(coachID: .away, index: 1),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....a...aaa
                        ....a...aaa
                        ....a...aaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        .......aaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify second run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(8, 7),
                        sq(7, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(8, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(7, 6),
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
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare first block

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
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
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0),
                    ]
                )
            )
        )

        // MARK: - Specify first block

        blockDieRandomizer.nextResults = [.smash, .smash]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.smash, .smash]),
                .selectedBlockDieResult(result: .smash),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 7)
                ),
                .playerAssistedBlock(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(6, 7)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .rolledForArmour(die: .d6, unmodified: 6),
                .turnEnded(coachID: .away),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .blockingPlay),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.first, .third])
            )
        )

        // MARK: - Discard objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(coachID: .home, objectiveID: .first),
                .dealtNewObjective(objectiveID: .first),
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
                                actionID: .standUp
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare stand up

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .standUp
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .standUp
                    ),
                    isFree: false
                ),
                .playerStoodUp(playerID: PlayerID(coachID: .home, index: 0)),
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare second block

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .home, index: 0),
                    validTargets: [
                        PlayerID(coachID: .away, index: 0),
                        PlayerID(coachID: .away, index: 1),
                    ]
                )
            )
        )

        // MARK: - Specify second block

        blockDieRandomizer.nextResults = [.shove]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .away, index: 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.shove]),
                .selectedBlockDieResult(result: .shove),
                .playerBlocked(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(7, 6)
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(8, 5),
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionEligibleForFollowUp(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(7, 6)
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
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(7, 6),
                    reason: .followUp
                ),
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
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .sidestep
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .sidestep
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 0),
                    validSquares: ValidMoveSquares(
                        intermediate: [],
                        final: [sq(8, 7), sq(7, 7), sq(6, 5)]
                    )
                )
            )
        )

        // MARK: - Specify sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(7, 7))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(7, 7),
                    reason: .sidestep
                ),
                .turnEnded(coachID: .home),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.first, .third])
            )
        )

        // MARK: - Discard objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectObjectiveToDiscard(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(coachID: .away, objectiveID: .third),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        // MARK: - Declare final run

        (latestEvents, latestPayload) = try game.process(
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
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaa.aa
                        aaaaaa...aa
                        aaaaaa...aa
                        aaaaaa...aa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ..aaaaaaa..
                        ...aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaaaa.....
                        aaaaaa.....
                        aaaaaa...a.
                        aaaaaaaaaa.
                        a..aaaaa...
                        ...aaaaa...
                        ..aaaaaaa..
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Can't run up to the target

        #expect(throws: GameError("Invalid final square")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(
                        squares: [
                            sq(6, 7),
                        ]
                    )
                )
            )
        }

        // MARK: - Can't run past the target

        #expect(throws: GameError("Invalid intermediate square")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(
                        squares: [
                            sq(6, 7),
                            sq(6, 8),
                            sq(6, 9),
                        ]
                    )
                )
            )
        }
    }
}
