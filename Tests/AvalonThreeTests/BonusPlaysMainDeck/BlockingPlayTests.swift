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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
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
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
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
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionEligibleForBlockingPlayBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .blockingPlay
                    ),
                    hand: []
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
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

        (latestEvents, latestPrompt) = try game.process(
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
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(2, 7),
                    to: sq(3, 7),
                    direction: .east,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(3, 7),
                    to: sq(4, 7),
                    direction: .east,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 7),
                    to: sq(5, 7),
                    direction: .east,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

    @Test func notAppliedIfDeclined() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
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
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
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
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionEligibleForBlockingPlayBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionDeclineBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
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
                            state: .held(playerID: pl(.away, 0))
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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare first run

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
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionEligibleForBlockingPlayBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .blockingPlay
                    ),
                    hand: []
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
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

        (latestEvents, latestPrompt) = try game.process(
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
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(2, 7),
                    to: sq(3, 7),
                    direction: .east,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(3, 7),
                    to: sq(4, 7),
                    direction: .east,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(4, 7),
                    to: sq(5, 7),
                    direction: .east,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

        // MARK: - Declare second run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
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
                        playerID: pl(.away, 1),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(9, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 1),
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

        (latestEvents, latestPrompt) = try game.process(
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
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(9, 7),
                    to: sq(8, 7),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(8, 7),
                    to: sq(7, 6),
                    direction: .northWest,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare first block

        blockDieRandomizer.nextResults = [.smash, .smash]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
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
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(5, 7)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash, .smash]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash, .smash]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(5, 7),
                    to: sq(6, 7),
                    direction: .east,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(7, 6),
                    to: sq(6, 7),
                    direction: .southWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(6, 7),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 6
                ),
                .turnEnded(coachID: .away),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .blockingPlay
                    )
                ),
                .updatedDiscards(
                    top: .blockingPlay,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.first, .third])
            )
        )

        // MARK: - Discard objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 2
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(top: nil, count: 0),
                .turnBegan(
                    coachID: .home,
                    isFinal: false
                ),
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

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
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
                        playerID: pl(.home, 0),
                        actionID: .standUp
                    ),
                    isFree: false,
                    playerSquare: sq(6, 7)
                ),
                .playerStoodUp(playerID: pl(.home, 0), in: sq(6, 7)),
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
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

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
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
                        playerID: pl(.home, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(6, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.home, 0),
                    validTargets: [
                        pl(.away, 0),
                        pl(.away, 1),
                    ]
                )
            )
        )

        // MARK: - Specify second block

        blockDieRandomizer.nextResults = [.shove]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .home, results: [.shove]),
                .selectedBlockDieResult(
                    coachID: .home,
                    result: .shove,
                    from: [.shove]
                ),
                .playerBlocked(
                    playerID: pl(.home, 0),
                    from: sq(6, 7),
                    to: sq(7, 6),
                    direction: .northEast,
                    targetPlayerID: pl(.away, 1)
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(7, 6),
                    to: sq(8, 5),
                    direction: .northEast,
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .blockActionEligibleForFollowUp(
                    playerID: pl(.home, 0),
                    square: sq(7, 6)
                )
            )
        )

        // MARK: - Follow up

        (latestEvents, latestPrompt) = try game.process(
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
                    from: sq(6, 7),
                    to: sq(7, 6),
                    direction: .northEast,
                    reason: .followUp
                )
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

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
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
                        playerID: pl(.home, 0),
                        actionID: .sidestep
                    ),
                    isFree: false,
                    playerSquare: sq(7, 6)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.home, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: [],
                        final: [sq(8, 7), sq(7, 7), sq(6, 5)]
                    )
                )
            )
        )

        // MARK: - Specify sidestep

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(7, 7))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(7, 6),
                    to: sq(7, 7),
                    direction: .south,
                    reason: .sidestep
                ),
                .turnEnded(coachID: .home),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.first, .third])
            )
        )

        // MARK: - Discard objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectObjectiveToDiscard(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .away,
                    objectiveID: .third,
                    objective: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 3
                ),
                .turnBegan(coachID: .away, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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
                                playerID: pl(.away, 0),
                                actionID: .pass
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
                    playerActionsLeft: 3
                )
            )
        )

        // MARK: - Declare final run

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(5, 7)
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
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
