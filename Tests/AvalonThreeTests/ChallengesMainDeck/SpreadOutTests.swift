//
//  SpreadOutTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/1/24.
//

import Testing
@testable import AvalonThree

struct SpreadOutTests {

    @Test func notAvailableWhenPlayersAreAdjacent() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(6, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(9, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.home, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .spreadOut,
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
                    playerSquare: sq(6, 8)
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
                        aaaaaaaaa..
                        aaaaa...aaa
                        a..aa.....a
                        a..aa.....a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ..aaaaaaaaa
                        ...aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaa..
                        aaaaa...aaa
                        a..aa.....a
                        ...aa.....a
                        .aaaaaa..aa
                        .aaaaaa....
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
                    sq(6, 7),
                    sq(6, 6),
                    sq(6, 5),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 8),
                    to: sq(6, 7),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 7),
                    to: sq(6, 6),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 6),
                    to: sq(6, 5),
                    direction: .north,
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func notAvailableWhenActionWasNotRunOrSidestep() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(6, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(8, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.home, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .spreadOut,
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
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
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
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(6, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaaaa..
                        ....aaaaa..
                        ....aaaa...
                        ....aaaaa..
                        ....aa.a...
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
                        .....aaa...
                        .....a.a...
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify mark

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(5, 8),
                    sq(6, 9),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 8),
                    to: sq(5, 8),
                    direction: .west,
                    reason: .mark
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(5, 8),
                    to: sq(6, 9),
                    direction: .southEast,
                    reason: .mark
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func availableWhenRunningAndNoPlayersAreAdjacent() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(6, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(8, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 10)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.home, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .spreadOut,
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
                    playerSquare: sq(6, 8)
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
                        aaaaaaaa.a.
                        aaaaa...aaa
                        a..aa.....a
                        a..aa.....a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ..aaaaaaaaa
                        ...aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaa.a.
                        aaaaa...aaa
                        a..aa.....a
                        ...aa.....a
                        .aaaaaa..aa
                        .aaaaaa....
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
                    sq(6, 7),
                    sq(6, 6),
                    sq(6, 5),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 8),
                    to: sq(6, 7),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 7),
                    to: sq(6, 6),
                    direction: .north,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 6),
                    to: sq(6, 5),
                    direction: .north,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.first]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .first,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 1,
                    total: 1
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func availableWhenSidesteppingAndNoPlayersAreAdjacent() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(6, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(8, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(6, 9)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.home, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .spreadOut,
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
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare sidestep

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
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
                        playerID: pl(.away, 0),
                        actionID: .sidestep
                    ),
                    isFree: false,
                    playerSquare: sq(6, 8)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: [],
                        final: [sq(5, 7), sq(6, 7), sq(7, 7)]
                    )
                )
            )
        )

        // MARK: - Specify sidestep

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSpecifySquare(square: sq(6, 7))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 8),
                    to: sq(6, 7),
                    direction: .north,
                    reason: .sidestep
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.first]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .first,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 1,
                    total: 1
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
                                playerID: pl(.away, 2),
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
}
