//
//  PassingPlayTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct PassingPlayTests {

    @Test func availableBeforePreTurnSequence() async throws {

        // MARK: - Init

        let d8Randomizer = D8RandomizerDouble()

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
                        coinFlipLoserTeamID: .ogre
                    ),
                    players: [
                        // We need a fake ogre team who're better at throwing, so we can test
                        // modified d8 rolls
                        Player(
                            id: pl(.away, 0),
                            spec: PlayerSpec(
                                move: .fixed(5),
                                block: 2,
                                pass: 3,
                                armour: 2,
                                skills: [.hulkingBrute, .hurlTeammate]
                            ),
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: PlayerSpec(
                                move: .fixed(5),
                                block: 1,
                                pass: 3,
                                armour: 6,
                                skills: [.titchy]
                            ),
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: PlayerSpec(
                                move: .fixed(5),
                                block: 1,
                                pass: 3,
                                armour: 6,
                                skills: [.titchy]
                            ),
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(8, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 8)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .passingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 1))
                        )
                    ],
                    deck: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
                    ],
                    objectives: Objectives(),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .home,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                ]
            ),
            previousPrompt: Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d8: d8Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare sidestep

        var (latestEvents, latestPayload) = try game.process(
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
                    playerSquare: sq(8, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
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
                        .......a...
                        .......a...
                        .......aaa.
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
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(8, 9))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(8, 8),
                    to: sq(8, 9),
                    direction: .south,
                    reason: .sidestep
                )
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
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
                        playerID: pl(.home, 1),
                        actionID: .sidestep
                    ),
                    isFree: false,
                    playerSquare: sq(9, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
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
                        .........aa
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
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(9, 9))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(9, 8),
                    to: sq(9, 9),
                    direction: .south,
                    reason: .sidestep
                )
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
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
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
                        playerID: pl(.home, 2),
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
                        playerID: pl(.home, 2),
                        actionID: .sidestep
                    ),
                    isFree: false,
                    playerSquare: sq(10, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.home, 2),
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
                        ..........a
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
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(10, 9))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 2),
                    ballID: nil,
                    from: sq(10, 8),
                    to: sq(10, 9),
                    direction: .south,
                    reason: .sidestep
                ), .turnEnded(coachID: .home),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForPassingPlayBonusPlay
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .usePassingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .passingPlay
                    ),
                    hand: []
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 1
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .second,
                    objective: .breakSomeBones
                ),
                .updatedDeck(top: nil, count: 0),
                .turnBegan(
                    coachID: .away,
                    isFinal: false
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
                                actionID: .hurlTeammate
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
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        // MARK: - Declare hurl teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .short, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .short, obstructingSquares: [sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 10), sq(2, 11), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 4), sq(2, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(2, 3), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(1, 11), sq(2, 10), sq(2, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(8, 9), sq(9, 9), sq(8, 10), sq(10, 9), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .short, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(8, 11), sq(9, 11), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 4), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: []),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d8Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(9, 12))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d8,
                    unmodified: 5
                ),
                .changedHurlTeammateResult(
                    die: .d8,
                    unmodified: 5,
                    modified: 4,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(2, 7),
                    to: sq(9, 12),
                    angle: 126
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    in: sq(9, 12)
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare pass

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
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
                        playerID: pl(.away, 1),
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(9, 12)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 1),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 0),
                            targetSquare: sq(2, 7),
                            distance: .long,
                            obstructingSquares: [sq(8, 11), sq(8, 10), sq(9, 11)],
                            markedTargetSquares: []
                        ),
                        PassTarget(
                            targetPlayerID: pl(.away, 2),
                            targetSquare: sq(9, 7),
                            distance: .long,
                            obstructingSquares: [sq(9, 11), sq(9, 9), sq(9, 10)],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d8Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 2))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d8,
                    unmodified: 5
                ),
                .changedPassResult(
                    die: .d8,
                    unmodified: 5,
                    modified: 4,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 1),
                    from: sq(9, 12),
                    to: sq(9, 7),
                    angle: 0,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 2),
                    in: sq(9, 7),
                    ballID: 123
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
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
                        playerID: pl(.away, 2),
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
                        playerID: pl(.away, 2),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(9, 7)
                )
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
                        ...........
                        ...........
                        ....aaaaaaa
                        ....aaaa..a
                        ....aaaa..a
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaaaaaa
                        ....aaa....
                        ....aaa....
                        ....aaa....
                        ....aaaa..a
                        ....aaaaa.a
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
                        ....aaaaaaa
                        ....aaa....
                        ....aaa....
                        ....aaa....
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
                    sq(8, 7),
                    sq(7, 7),
                    sq(6, 7),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(9, 7),
                    to: sq(8, 7),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(8, 7),
                    to: sq(7, 7),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: 123,
                    from: sq(7, 7),
                    to: sq(6, 7),
                    direction: .west,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .passingPlay
                    )
                ),
                .updatedDiscards(
                    top: .passingPlay,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.first, .second])
            )
        )
    }

    @Test func notAppliedIfDeclined() async throws {

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
                        coinFlipLoserTeamID: .ogre
                    ),
                    players: [
                        // We need a fake ogre team who're better at throwing, so we can test
                        // modified d8 rolls
                        Player(
                            id: pl(.away, 0),
                            spec: PlayerSpec(
                                move: .fixed(5),
                                block: 2,
                                pass: 3,
                                armour: 2,
                                skills: [.hulkingBrute, .hurlTeammate]
                            ),
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: PlayerSpec(
                                move: .fixed(5),
                                block: 1,
                                pass: 3,
                                armour: 6,
                                skills: [.titchy]
                            ),
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: PlayerSpec(
                                move: .fixed(5),
                                block: 1,
                                pass: 3,
                                armour: 6,
                                skills: [.titchy]
                            ),
                            state: .standing(square: sq(9, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(8, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 8)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .passingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 1))
                        )
                    ],
                    deck: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
                    ],
                    objectives: Objectives(),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .home,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                ]
            ),
            previousPrompt: Prompt(
                coachID: .home,
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

        // MARK: - Declare sidestep

        var (latestEvents, latestPayload) = try game.process(
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
                    playerSquare: sq(8, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
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
                        .......a...
                        .......a...
                        .......aaa.
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
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(8, 9))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(8, 8),
                    to: sq(8, 9),
                    direction: .south,
                    reason: .sidestep
                )
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
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
                        playerID: pl(.home, 1),
                        actionID: .sidestep
                    ),
                    isFree: false,
                    playerSquare: sq(9, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
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
                        .........aa
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
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(9, 9))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 1),
                    ballID: nil,
                    from: sq(9, 8),
                    to: sq(9, 9),
                    direction: .south,
                    reason: .sidestep
                )
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
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
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
                        playerID: pl(.home, 2),
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
                        playerID: pl(.home, 2),
                        actionID: .sidestep
                    ),
                    isFree: false,
                    playerSquare: sq(10, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.home, 2),
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
                        ..........a
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
                coachID: .home,
                message: .sidestepActionSpecifySquare(square: sq(10, 9))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 2),
                    ballID: nil,
                    from: sq(10, 8),
                    to: sq(10, 9),
                    direction: .south,
                    reason: .sidestep
                ),
                .turnEnded(coachID: .home),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForPassingPlayBonusPlay
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declinePassingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 1
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .second,
                    objective: .breakSomeBones
                ),
                .updatedDeck(top: nil, count: 0),
                .turnBegan(
                    coachID: .away,
                    isFinal: false
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
                                actionID: .hurlTeammate
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
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        // MARK: - Declare hurl teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .short, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .short, obstructingSquares: [sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 10), sq(2, 11), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 4), sq(2, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(2, 3), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(1, 11), sq(2, 10), sq(2, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(8, 9), sq(9, 9), sq(8, 10), sq(10, 9), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .short, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(8, 11), sq(9, 11), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 4), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: []),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(9, 12))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .changedHurlTeammateResult(
                    die: .d6,
                    unmodified: 5,
                    modified: 4,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(2, 7),
                    to: sq(9, 12),
                    angle: 126
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    in: sq(9, 12)
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare pass

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
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
                        playerID: pl(.away, 1),
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(9, 12)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 1),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 0),
                            targetSquare: sq(2, 7),
                            distance: .long,
                            obstructingSquares: [sq(8, 11), sq(8, 10), sq(9, 11)],
                            markedTargetSquares: []
                        ),
                        PassTarget(
                            targetPlayerID: pl(.away, 2),
                            targetSquare: sq(9, 7),
                            distance: .long,
                            obstructingSquares: [sq(9, 11), sq(9, 9), sq(9, 10)],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 2))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 5,
                    modified: 4,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 1),
                    from: sq(9, 12),
                    to: sq(9, 7),
                    angle: 0,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 2),
                    in: sq(9, 7),
                    ballID: 123
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

    }
}
