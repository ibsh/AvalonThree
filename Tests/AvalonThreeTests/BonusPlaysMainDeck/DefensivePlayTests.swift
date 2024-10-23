//
//  DefensivePlayTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct DefensivePlayTests {

    @Test func availableBeforePreTurnSequence() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .defensivePlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare first run

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select first run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 11),
                        sq(10, 10),
                        sq(10, 9),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(4, 7),
                    sq(3, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare second mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(10, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForDefensivePlayBonusPlay)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useDefensivePlayBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .dealtNewObjective,
                .updatedDeck,
                .dealtNewObjective,
                .updatedDeck,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.kerrunch, .smash))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 7)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.kerrunch, .smash])
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .blockActionSelectResult)
    }

    @Test func notAppliedIfDeclined() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .defensivePlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare first run

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select first run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 11),
                        sq(10, 10),
                        sq(10, 9),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(4, 7),
                    sq(3, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare second mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(10, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForDefensivePlayBonusPlay)

        // Decline bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineDefensivePlayBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .dealtNewObjective,
                .updatedDeck,
                .dealtNewObjective,
                .updatedDeck,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.miss))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 7)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.miss])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.miss])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 7),
                    to: sq(3, 8),
                    direction: .southEast,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(2, 7)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func noLongerAppliedToSubsequentTurn() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(10, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(9, 12)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .defensivePlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .absoluteCarnage),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare first run

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select first run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .runActionSelectSquares(
                    squares: [
                        sq(10, 11),
                        sq(10, 10),
                        sq(10, 9),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(4, 7),
                    sq(3, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare second mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select first mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(10, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .turnEnded
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .eligibleForDefensivePlayBonusPlay)

        // Use bonus play

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useDefensivePlayBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .dealtNewObjective,
                .updatedDeck,
                .dealtNewObjective,
                .updatedDeck,
                .dealtNewObjective,
                .updatedDeck,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.miss, .miss))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 7)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.miss, .miss])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.miss, .miss])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 7),
                    to: sq(3, 8),
                    direction: .southEast,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(2, 7)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .sidestep
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
        #expect(latestAddressedPrompt?.prompt.case == .sidestepActionSelectSquare)

        // Select sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSelectSquare(square: sq(9, 6))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .mark
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
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
                    sq(9, 7),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .turnEnded,
                .playerCanTakeActions,
                .discardedActiveBonusPlay,
                .updatedDiscards,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .selectObjectiveToDiscard)

        // Discard objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .discardedObjective,
                .updatedDiscards,
                .dealtNewObjective,
                .updatedDeck,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .sidestepActionSelectSquare)

        // Select sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .sidestepActionSelectSquare(square: sq(10, 9))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .sidestepActionSelectSquare)

        // Select sidestep

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .sidestepActionSelectSquare(square: sq(4, 9))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 1),
                        actionID: .mark
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

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .markActionSelectSquares)

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .markActionSelectSquares(squares: [
                    sq(10, 8),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .turnEnded,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .selectObjectiveToDiscard)

        // Discard objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectObjectiveToDiscard(objectiveIndex: 0)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .discardedObjective,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare (final!) block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(3))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(9, 7)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.smash])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.smash])
                ),
                .playerBlocked(
                    playerID: pl(.away, 1),
                    from: sq(9, 7),
                    to: sq(10, 8),
                    direction: .southEast,
                    targetPlayerID: pl(.home, 1),
                    assistingPlayers: []
                ),
                .playerFellDown(
                    playerID: pl(.home, 1),
                    playerSquare: sq(10, 8),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 3
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func canEarnGangUp() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(4, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .defensivePlay),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .loose(square: sq(0, 0))
                        )
                    ],
                    deck: [
                        ChallengeCard(challenge: .gangUp, bonusPlay: .legUp),
                    ],
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
                prompt: .eligibleForDefensivePlayBonusPlay
            )
        )

        // Use bonus play

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useDefensivePlayBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .dealtNewObjective,
                .updatedDeck,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(blockDie: block(.kerrunch, .smash))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .blockActionSelectResult)

        // Choose block result

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(
                    dieIndex: 0
                )
            ),
            randomizers: Randomizers(d6: d6(6))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .rolledForArmour,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)
    }
}
