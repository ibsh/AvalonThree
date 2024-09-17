//
//  MoveTheBallTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/30/24.
//

import Testing
@testable import AvalonThree

struct MoveTheBallTests {

    @Test func notAvailableWhenBallMovesLessThanFourSquares() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(6, 2)),
                            canTakeActions: true
                        )
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .moveTheBall,
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
                )
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
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
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
                message: .runActionSpecifySquares(squares: [
                    sq(6, 3),
                    sq(6, 4),
                    sq(6, 5),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 3),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 4),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 5),
                    reason: .run
                ),
                .turnEnded(coachID: .away),
                .discardedObjective(coachID: .home, objectiveID: .first),
                .finalTurnBegan,
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

    @Test func availableWhenBallMovesFourSquares() async throws {

        // MARK: - Init

        let ballID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(6, 2)),
                            canTakeActions: true
                        )
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .moveTheBall,
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
                )
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
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
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
                message: .runActionSpecifySquares(squares: [
                    sq(6, 3),
                    sq(6, 4),
                    sq(6, 5),
                    sq(6, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 3),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 4),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 5),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 6),
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
                    objectiveID: .first
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 1),
                .turnEnded(coachID: .away),
                .finalTurnBegan,
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

    @Test func availableAlongsideScoringTouchdown() async throws {

        // MARK: - Init

        let heldBallID = DefaultUUIDProvider().generate()
        let looseBallID = DefaultUUIDProvider().generate()

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
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(6, 9)),
                            canTakeActions: true
                        )
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: heldBallID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        ),
                        Ball(
                            id: looseBallID,
                            state: .loose(square: sq(0, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .moveTheBall,
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
                )
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
                        ...........
                        ...........
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
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
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
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

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(6, 10),
                    sq(6, 11),
                    sq(6, 12),
                    sq(6, 13),
                    sq(6, 14),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 10),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 11),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 12),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 14),
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
                    objectiveID: .first
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 1),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: heldBallID
                ),
                .scoreUpdated(coachID: .away, increment: 4, total: 5),
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
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        )
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }
}
