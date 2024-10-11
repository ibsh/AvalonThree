//
//  ReservesTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct ReservesTests {

    @Test func usedWithoutEmergencyReserves() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
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
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForReservesBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
                    playerID: pl(.home, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .reserves
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .reserves
                        ),
                    ]
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedWithoutEmergencyReserves() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
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
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForReservesBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineReservesBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedWithEmergencyReserves() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
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
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declareEmergencyReservesAction)

        // Declare emergency reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: pl(.home, 3)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForReservesBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
                    playerID: pl(.home, 1)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(1, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedWithEmergencyReserves() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
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
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 3),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declareEmergencyReservesAction)

        // Declare emergency reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declareEmergencyReservesAction(
                    playerID: pl(.home, 3)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForReservesBonusPlayReservesAction)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineReservesBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func cantUseTwiceInOneTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .orc,
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
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .orc_lineman,
                            state: .inReserves,
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .reserves),
                        ChallengeCard(challenge: .breakTheirLines, bonusPlay: .reserves),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(
                                playerID: PlayerID(
                                    coachID: .away,
                                    index: 0
                                )
                            )
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForReservesBonusPlayReservesAction)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useReservesBonusPlayReservesAction(
                    playerID: pl(.home, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .reserves
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .breakTheirLines,
                                bonusPlay: .reserves
                            )
                        ),
                    ],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .reserves
                        ),
                    ]
                ),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .reserves
                    ),
                    isFree: true,
                    playerSquare: nil
                )
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .reservesActionSelectSquare)

        // Select reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSelectSquare(square: sq(7, 14))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMovedOutOfReserves,
                .discardedActiveBonusPlay,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
