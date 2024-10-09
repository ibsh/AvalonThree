//
//  SuddenDeathTests.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/27/24.
//

import Testing
@testable import AvalonThree

struct SuddenDeathTests {

    @Test func possibleBeforeEndgame() async throws {

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
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 7,
                    coinFlipWinnerScore: 21,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    discards: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                    ]
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
                    playerSquare: sq(6, 10)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 10),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        .aaaaaaaaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ......aaaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(6, 11),
                        sq(6, 12),
                        sq(6, 13),
                        sq(6, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 10),
                    to: sq(6, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 11),
                    to: sq(6, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 12),
                    to: sq(6, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 13),
                    to: sq(6, 14),
                    direction: .south,
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 14),
                    ballID: 123
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 4,
                    total: 11
                ),
                .gameEnded(
                    endConditions: .suddenDeath(coachID: .home)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == nil
        )
    }

    @Test func impossibleAfterAnEndgameCardIsDealt() async throws {

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
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 7,
                    coinFlipWinnerScore: 21,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .breakTheirLines,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    discards: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                    ]
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
                    playerSquare: sq(6, 10)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 10),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        .aaaaaaaaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ......aaaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(6, 11),
                        sq(6, 12),
                        sq(6, 13),
                        sq(6, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 10),
                    to: sq(6, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 11),
                    to: sq(6, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 12),
                    to: sq(6, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 13),
                    to: sq(6, 14),
                    direction: .south,
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 14),
                    ballID: 123
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 4,
                    total: 11
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectObjectiveToDiscard(
                    objectives: [
                        0: .breakSomeBones,
                        1: .breakSomeBones,
                        2: .breakTheirLines
                    ]
                )
            )
        )
    }

    @Test func impossibleAfterAnEndgameCardIsDiscarded() async throws {

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
                            state: .standing(square: sq(6, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 7,
                    coinFlipWinnerScore: 21,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    discards: [
                        ChallengeCard(
                            challenge: .breakTheirLines,
                            bonusPlay: .absoluteCarnage
                        ),
                    ]
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.away, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
                    playerSquare: sq(6, 10)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 10),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        .aaaaaaaaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ......aaaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaa...aaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(6, 11),
                        sq(6, 12),
                        sq(6, 13),
                        sq(6, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 10),
                    to: sq(6, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 11),
                    to: sq(6, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 12),
                    to: sq(6, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 13),
                    to: sq(6, 14),
                    direction: .south,
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 14),
                    ballID: 123
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 4,
                    total: 11
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectObjectiveToDiscard(
                    objectives: [
                        0: .breakSomeBones,
                        1: .breakSomeBones,
                        2: .breakSomeBones,
                    ]
                )
            )
        )
    }
}
