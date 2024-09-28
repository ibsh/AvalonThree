//
//  YourTimeToShineTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct YourTimeToShineTests {

    @Test func useFreeActions() async throws {

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
                        coinFlipLoserTeamID: .noble
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .noble_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .noble_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .noble_passer,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .noble_blitzer,
                            state: .standing(square: sq(8, 11)),
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
                            state: .loose(square: sq(5, 6))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .yourTimeToShine
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

        // MARK: - Declare reserves

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .reserves
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
                        actionID: .reserves
                    ),
                    isFree: false,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: pl(.away, 2),
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
                        aaaaaaaaaaa
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
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(6, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 2),
                    to: sq(6, 0)
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
                                playerID: pl(CoachID.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 3),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 4),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        .aaaaaaaaa.
                        .aaaaaaaaa.
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
                        sq(5, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(5, 7),
                    to: sq(5, 6),
                    direction: .north,
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: pl(.away, 0),
                    in: sq(5, 6),
                    ballID: ballID
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
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
                            challenge: .getTheBall,
                            bonusPlay: .yourTimeToShine
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .yourTimeToShine
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 1,
                    total: 1
                ),
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .yourTimeToShine
                    ),
                    hand: []
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForYourTimeToShineBonusPlayReservesAction(
                    validPlayers: [
                        pl(.away, 1),
                        pl(.away, 3),
                        pl(.away, 4),
                    ]
                )
            )
        )

        // MARK: - Use reserves action

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useYourTimeToShineBonusPlayReservesAction(
                    playerID: pl(.away, 3)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: pl(.away, 3),
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
                        aaaaaa.aaaa
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
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(2, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 3),
                    to: sq(2, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForYourTimeToShineBonusPlayReservesAction(
                    validPlayers: [
                        pl(.away, 1),
                        pl(.away, 4),
                    ]
                )
            )
        )

        // MARK: - Use reserves action

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useYourTimeToShineBonusPlayReservesAction(
                    playerID: pl(.away, 4)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 4),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: pl(.away, 4),
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
                        aa.aaa.aaaa
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
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(8, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 4),
                    to: sq(8, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForYourTimeToShineBonusPlayRunAction(
                    validPlayers: [
                        pl(.away, 2),
                        pl(.away, 3),
                        pl(.away, 4),
                    ]
                )
            )
        )

        // MARK: - Use run action

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useYourTimeToShineBonusPlayRunAction(
                    playerID: pl(.away, 3)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: true,
                    playerSquare: sq(2, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaa.a...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaa.aaa..
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
                        aaaaaa.a...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaa.aaa..
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

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(1, 1),
                        sq(0, 2),
                        sq(0, 3),
                        sq(0, 4),
                        sq(1, 5),
                        sq(2, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(2, 0),
                    to: sq(1, 1),
                    direction: .southWest,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(1, 1),
                    to: sq(0, 2),
                    direction: .southWest,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(0, 2),
                    to: sq(0, 3),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(0, 3),
                    to: sq(0, 4),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(0, 4),
                    to: sq(1, 5),
                    direction: .southEast,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(1, 5),
                    to: sq(2, 6),
                    direction: .southEast,
                    reason: .run
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .yourTimeToShine
                    )
                ),
                .updatedDiscards(
                    top: .yourTimeToShine,
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
                                playerID: pl(CoachID.away, 0),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )
    }

    @Test func declineFreeActions() async throws {

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
                        coinFlipLoserTeamID: .noble
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .noble_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .noble_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .noble_passer,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .noble_guard,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .noble_blitzer,
                            state: .standing(square: sq(8, 11)),
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
                            state: .loose(square: sq(5, 6))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .yourTimeToShine
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
                    playerSquare: sq(5, 7)
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
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        .aaaaaaaaa.
                        .aaaaaaaaa.
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
                        sq(5, 6),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(5, 7),
                    to: sq(5, 6),
                    direction: .north,
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: pl(.away, 0),
                    in: sq(5, 6),
                    ballID: ballID
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
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
                            challenge: .getTheBall,
                            bonusPlay: .yourTimeToShine
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .yourTimeToShine
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 1,
                    total: 1
                ),
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .yourTimeToShine
                    ),
                    hand: []
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForYourTimeToShineBonusPlayReservesAction(
                    validPlayers: [
                        pl(.away, 1),
                        pl(.away, 2),
                        pl(.away, 3),
                        pl(.away, 4),
                    ]
                )
            )
        )

        // MARK: - Decline reserves action

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineYourTimeToShineBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForYourTimeToShineBonusPlayReservesAction(
                    validPlayers: [
                        pl(.away, 1),
                        pl(.away, 2),
                        pl(.away, 3),
                        pl(.away, 4),
                    ]
                )
            )
        )

        // MARK: - Decline reserves action

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineYourTimeToShineBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .yourTimeToShine
                    )
                ),
                .updatedDiscards(
                    top: .yourTimeToShine,
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
                                playerID: pl(CoachID.away, 0),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 2),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 3),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 4),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 5),
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
