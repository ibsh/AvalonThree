//
//  GetTheBallTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/29/24.
//

import Testing
@testable import AvalonThree

struct GetTheBallTests {

    @Test func notAvailableWhenBallRemainsOutOfPossession() async throws {

        // MARK: - Init

        let looseBallID = 456

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
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        )
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
                            id: looseBallID,
                            state: .loose(square: sq(5, 8))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
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
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
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
                message: .runActionSpecifySquares(squares: [
                    sq(3, 7),
                    sq(3, 8),
                    sq(3, 9),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 6),
                    to: sq(3, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 7),
                    to: sq(3, 8),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 8),
                    to: sq(3, 9),
                    direction: .south,
                    reason: .run
                ), .turnEnded(coachID: .away),
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: ChallengeCard(
                        challenge: .getTheBall,
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
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func availableWhenTakingPossession() async throws {

        // MARK: - Init

        let looseBallID = 456

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
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        )
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
                            id: looseBallID,
                            state: .loose(square: sq(5, 8))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
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
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
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
                message: .runActionSpecifySquares(squares: [
                    sq(4, 7),
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
                    from: sq(3, 6),
                    to: sq(4, 7),
                    direction: .southEast,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(5, 8),
                    direction: .southEast,
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: pl(.away, 0),
                    in: sq(5, 8),
                    ballID: 456
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 456,
                    from: sq(5, 8),
                    to: sq(6, 9),
                    direction: .southEast,
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
                            challenge: .getTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay:
                                    .absoluteCarnage
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 1,
                    total: 1
                ),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func notAvailableWhenPassedAfterTakingPossession() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(6, 6)),
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
                            state: .loose(square: sq(4, 6))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .getTheBall, bonusPlay: .absoluteCarnage),
                        second: ChallengeCard(challenge: .getTheBall, bonusPlay: .absolutelyNails)
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
                d6: d6Randomizer
            ),
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
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaa.aa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaa.aa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
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
                message: .runActionSpecifySquares(squares: [
                    sq(4, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 6),
                    to: sq(4, 6),
                    direction: .east,
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: pl(.away, 0),
                    in: sq(4, 6),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.first, .second]
                )
            )
        )

        // MARK: - Decline objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineToClaimObjective
            )
        )

        #expect(
            latestEvents == [
                .declinedObjectives(
                    coachID: .away,
                    objectives: [
                        .first: .getTheBall,
                        .second: .getTheBall,
                    ]
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
                    playerSquare: sq(4, 6)
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
                            targetSquare: sq(6, 6),
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
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 4
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(4, 6),
                    to: sq(6, 6),
                    angle: 90,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(6, 6),
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
                    ],
                    playerActionsLeft: 1
                )
            )
        )
    }
}
