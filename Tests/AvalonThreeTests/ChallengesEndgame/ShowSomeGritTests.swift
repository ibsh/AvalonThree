//
//  ShowSomeGritTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/2/24.
//

import Testing
@testable import AvalonThree

struct ShowSomeGritTests {

    @Test func notAvailableWhenNotAtLeastFourPointsBehind() async throws {

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
                        coinFlipWinnerTeamID: .halfling,
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
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(3, 3)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 3,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .showSomeGrit,
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
                            actionID: .block
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
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
                        .....aaa..a
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
                        .....aaa..a
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
                message: .runActionSpecifySquares(squares: [
                    sq(10, 9),
                ])
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
                ), .turnEnded(coachID: .away),
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: ChallengeCard(
                        challenge: .showSomeGrit,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declareEmergencyReservesAction(validPlayers: [
                    pl(.home, 1),
                    pl(.home, 2),
                ])
            )
        )

        // MARK: - Declare emergency reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: pl(.home, 2)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 2),
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
                    playerID: pl(.home, 2),
                    validSquares: ValidMoveSquares(
                        intermediate: [],
                        final: [sq(7, 14), sq(2, 14), sq(0, 14), sq(3, 14), sq(1, 14), sq(8, 14), sq(5, 14), sq(4, 14), sq(10, 14), sq(9, 14), sq(6, 14)]
                    )
                )
            )
        )

        // MARK: - Specify emergency reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(5, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 2),
                    to: sq(5, 14)
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
                                actionID: .run
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

    @Test func notAvailableWithoutAnEmergencyReservesAction() async throws {

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
                        coinFlipWinnerTeamID: .halfling,
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
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(3, 3)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(7, 3)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 8,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .showSomeGrit,
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
                            actionID: .block
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
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
                        .....a....a
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
                        .....a....a
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
                message: .runActionSpecifySquares(squares: [
                    sq(10, 9),
                ])
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
                .turnEnded(coachID: .away),
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: ChallengeCard(
                        challenge: .showSomeGrit,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
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
                                actionID: .run
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

        // MARK: - Declare run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
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
                        playerID: pl(.home, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 3)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .runActionSpecifySquares(
                    playerID: pl(.home, 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaa....
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaa....
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
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

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .runActionSpecifySquares(squares: [
                    sq(3, 2),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(3, 3),
                    to: sq(3, 2),
                    direction: .north,
                    reason: .run
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
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func availableWhenAtLeastFourPointsBehindAndMadeAnEmergencyReservesAction() async throws {

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
                        coinFlipWinnerTeamID: .halfling,
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
                            spec: .halfling_hopeful,
                            state: .standing(square: sq(3, 3)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .halfling_hopeful,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 4,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .showSomeGrit,
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
                            actionID: .block
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
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
                        .....aaa..a
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
                        .....aaa..a
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
                message: .runActionSpecifySquares(squares: [
                    sq(10, 9),
                ])
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
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.second, .third])
            )
        )

        // MARK: - Discard objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .third,
                    objective: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declareEmergencyReservesAction(validPlayers: [
                    pl(.home, 1),
                    pl(.home, 2),
                ])
            )
        )

        // MARK: - Declare emergency reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: pl(.home, 2)
                )
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 2),
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
                    playerID: pl(.home, 2),
                    validSquares: ValidMoveSquares(
                        intermediate: [],
                        final: [sq(10, 14), sq(3, 14), sq(0, 14), sq(5, 14), sq(6, 14), sq(4, 14), sq(8, 14), sq(1, 14), sq(2, 14), sq(7, 14), sq(9, 14)]
                    )
                )
            )
        )

        // MARK: - Specify emergency reserves

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(5, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 2),
                    to: sq(5, 14)
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .earnedObjective(
                    objectiveIDs: [.second]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .showSomeGrit,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .showSomeGrit,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ]
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
                                actionID: .run
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
