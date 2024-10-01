//
//  DodgeTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct DodgeTests {

    @Test func cannotMoveAdjacentToPlayersIfDeclined() async throws {

        // Init

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
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .dodge)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForDodgeBonusPlay)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionDeclineDodgeBonusPlay
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
                    in: sq(3, 5),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        ...aaaaa...
                        ...aaaaaaa.
                        ...aaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        ...aaaaa...
                        ...aaaaaaa.
                        ...aaaaaaa.
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

        #expect(throws: GameError("Invalid intermediate square")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(squares: [
                        sq(2, 5),
                        sq(1, 6),
                        sq(0, 5),
                        sq(0, 4),
                        sq(0, 3),
                    ])
                )
            )
        }
    }

    @Test func canMoveAdjacentToPlayersAndPickUpMarkedBallIfUsed() async throws {

        // Init

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
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .dodge)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .loose(square: sq(2, 5))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForDodgeBonusPlay)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseDodgeBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    in: sq(3, 5),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        a.aaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        ...aaaaa...
                        ...aaaaaaa.
                        ...aaaaaaa.
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

        // Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(2, 5),
                    sq(1, 6),
                    sq(0, 5),
                    sq(0, 4),
                    sq(0, 3),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerPickedUpLooseBall,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func cannotStopAdjacentToPlayersIfUsed() async throws {

        // Init

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
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .dodge)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForDodgeBonusPlay)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseDodgeBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        #expect(throws: GameError("Invalid final square")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSpecifySquares(squares: [
                        sq(2, 5),
                        sq(1, 6),
                        sq(0, 7),
                        sq(0, 6),
                    ])
                )
            )
        }
    }

    @Test func cannotMoveThroughPlayersIfUsed() async throws {

        // Init

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
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .dodge)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForDodgeBonusPlay)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseDodgeBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        #expect(throws: GameError("Invalid intermediate square")) {
            (latestEvents, latestPrompt) = try game.process(
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

    @Test func eligibleForDodgeAfterDecliningBlockingPlay() async throws {

        // Init

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
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .dodge),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForBlockingPlayBonusPlay)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionDeclineBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForDodgeBonusPlay)
    }

    @Test func canUseDodgeAsWellAsBlockingPlayAndItGivesYouTheBestOfBothWorlds() async throws {

        // Init

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
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .dodge),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare run

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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForBlockingPlayBonusPlay)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseBlockingPlayBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionEligibleForDodgeBonusPlay)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionUseDodgeBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(2, 5),
                    sq(1, 6),
                    sq(0, 5),
                    sq(0, 4),
                    sq(0, 5),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
