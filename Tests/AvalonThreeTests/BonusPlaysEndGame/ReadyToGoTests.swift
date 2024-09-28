//
//  ReadyToGoTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct ReadyToGoTests {

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
                        coinFlipLoserTeamID: .lizardmen
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .lizardmen_skinkRunner,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .lizardmen_skinkRunner,
                            state: .standing(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .lizardmen_chameleonSkinkCatcher,
                            state: .prone(square: sq(3, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .lizardmen_saurusBlocker,
                            state: .standing(square: sq(6, 13)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .lizardmen_saurusBlocker,
                            state: .standing(square: sq(9, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .lizardmen_saurusBlocker,
                            state: .standing(square: sq(8, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 12)),
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
                            bonusPlay: .readyToGo
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
                    playerSquare: sq(5, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaa.aaaaaaa
                        aaaaaaaaa.a
                        a..aaaaa..a
                        a..aa.....a
                        aaaaaa...aa
                        aaaaaa...aa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaa.aaaaaaa
                        aaaaaaaaa.a
                        a..aaaaa..a
                        a..aa.....a
                        aaaaaa...aa
                        aaaaaa.....
                        aaaaaaaa...
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
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPrompt) = try game.process(
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
                            bonusPlay: .readyToGo
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .readyToGo
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
                        bonusPlay: .readyToGo
                    ),
                    hand: []
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlayRunAction(
                    playerID: pl(.away, 1)
                )
            )
        )

        // MARK: - Use run action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useReadyToGoBonusPlayRunAction
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .run
                    ),
                    isFree: true,
                    playerSquare: sq(5, 11)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 1),
                    maxRunDistance: 1,
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
                        ....aaa....
                        ....aa.....
                        ....aa.....
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
                        ....aaa....
                        ....aa.....
                        ....aa.....
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
                        sq(4, 12),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(5, 11),
                    to: sq(4, 12),
                    direction: .southWest,
                    reason: .run
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlayRunAction(
                    playerID: pl(.away, 4)
                )
            )
        )

        // MARK: - Use run action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useReadyToGoBonusPlayRunAction
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 4),
                        actionID: .run
                    ),
                    isFree: true,
                    playerSquare: sq(9, 9)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 4),
                    maxRunDistance: 1,
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
                        ........aaa
                        ........aaa
                        ..........a
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
                        ........aaa
                        ........aaa
                        ..........a
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
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(10, 9),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 4),
                    ballID: nil,
                    from: sq(9, 9),
                    to: sq(10, 9),
                    direction: .east,
                    reason: .run
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlaySidestepAction(
                    playerID: pl(.away, 3)
                )
            )
        )

        // MARK: - Use sidestep action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useReadyToGoBonusPlaySidestepAction
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 3),
                        actionID: .sidestep
                    ),
                    isFree: true,
                    playerSquare: sq(6, 13)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
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
                        .....a.....
                        .....a.....
                        .....aaa...
                        """)
                    )
                )
            )
        )

        // MARK: - Specify sidestep

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSpecifySquare(square: sq(5, 13))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 13),
                    to: sq(5, 13),
                    direction: .west,
                    reason: .sidestep
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlaySidestepAction(
                    playerID: pl(.away, 5)
                )
            )
        )

        // MARK: - Use sidestep action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useReadyToGoBonusPlaySidestepAction
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 5),
                        actionID: .sidestep
                    ),
                    isFree: true,
                    playerSquare: sq(8, 11)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .sidestepActionSpecifySquare(
                    playerID: pl(.away, 5),
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
                        .......a...
                        ...........
                        .........a.
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
                message: .sidestepActionSpecifySquare(square: sq(9, 12))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 5),
                    ballID: nil,
                    from: sq(8, 11),
                    to: sq(9, 12),
                    direction: .southEast,
                    reason: .sidestep
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlayStandUpAction(
                    playerID: pl(.away, 2)
                )
            )
        )

        // MARK: - Use stand up action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useReadyToGoBonusPlayStandUpAction
            )
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 2),
                        actionID: .standUp
                    ),
                    isFree: true,
                    playerSquare: sq(3, 8)
                ),
                .playerStoodUp(
                    playerID: pl(.away, 2),
                    in: sq(3, 8)
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .readyToGo
                    )
                ),
                .updatedDiscards(
                    top: .readyToGo,
                    count: 1
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
                                playerID: pl(CoachID.away, 0),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 1),
                                actionID: .mark
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 3),
                                actionID: .mark
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
                        coinFlipLoserTeamID: .lizardmen
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .lizardmen_skinkRunner,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .lizardmen_skinkRunner,
                            state: .standing(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .lizardmen_chameleonSkinkCatcher,
                            state: .prone(square: sq(3, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 3),
                            spec: .lizardmen_saurusBlocker,
                            state: .standing(square: sq(6, 13)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 4),
                            spec: .lizardmen_saurusBlocker,
                            state: .standing(square: sq(9, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 5),
                            spec: .lizardmen_saurusBlocker,
                            state: .standing(square: sq(8, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 12)),
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
                            bonusPlay: .readyToGo
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
                    playerSquare: sq(5, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaa.aaaaaaa
                        aaaaaaaaa.a
                        a..aaaaa..a
                        a..aa.....a
                        aaaaaa...aa
                        aaaaaa...aa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaa.aaaaaaa
                        aaaaaaaaa.a
                        a..aaaaa..a
                        a..aa.....a
                        aaaaaa...aa
                        aaaaaa.....
                        aaaaaaaa...
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
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPrompt) = try game.process(
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
                            bonusPlay: .readyToGo
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .readyToGo
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
                        bonusPlay: .readyToGo
                    ),
                    hand: []
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlayRunAction(
                    playerID: pl(.away, 1)
                )
            )
        )

        // MARK: - Decline run action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineReadyToGoBonusPlayRunAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlayRunAction(
                    playerID: pl(.away, 4)
                )
            )
        )

        // MARK: - Decline run action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineReadyToGoBonusPlayRunAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlaySidestepAction(
                    playerID: pl(.away, 3)
                )
            )
        )

        // MARK: - Decline sidestep action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineReadyToGoBonusPlaySidestepAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlaySidestepAction(
                    playerID: pl(.away, 5)
                )
            )
        )

        // MARK: - Decline sidestep action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineReadyToGoBonusPlaySidestepAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .eligibleForReadyToGoBonusPlayStandUpAction(
                    playerID: pl(.away, 2)
                )
            )
        )

        // MARK: - Decline stand up action

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineReadyToGoBonusPlayStandUpAction
            )
        )

        #expect(
            latestEvents == [
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .readyToGo
                    )
                ),
                .updatedDiscards(
                    top: .readyToGo,
                    count: 1
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
                                playerID: pl(CoachID.away, 0),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 2),
                                actionID: .standUp
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 3),
                                actionID: .block
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
                                playerID: pl(CoachID.away, 3),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 5),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(CoachID.away, 5),
                                actionID: .sidestep
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
