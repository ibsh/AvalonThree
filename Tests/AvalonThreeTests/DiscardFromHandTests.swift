//
//  DiscardFromHandTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct DiscardFromHandTests {

    @Test func notPromptedWhenOnlyHoldingThreeCards() async throws {

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
                        coinFlipLoserTeamID: .undead
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .undead_wight,
                            state: .standing(square: sq(6, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .undead_ghoul,
                            state: .standing(square: sq(6, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 6)),
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
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .blitz
                        ),
                        second: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        third: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        )
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    )
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        var (latestEvents, latestPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.smash))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(6, 6)
                ),
                .rolledForBlock(coachID: .away, results: [.smash]),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 6),
                    results: [.smash]
                )
            )
        )

        // Choose to reroll

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseOffensiveSpecialistSkillReroll
            ),
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(6), direction: direction(.northWest))
        )

        #expect(
            latestEvents == [
                .usedOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 6)
                ),
                .rolledForBlock(coachID: .away, results: [.smash]),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(6, 6),
                    to: sq(7, 6),
                    direction: .east,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(7, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(7, 6)),
                .rolledForDirection(coachID: .away, direction: .northWest),
                .ballBounced(
                    ballID: 123,
                    from: sq(7, 6),
                    to: sq(6, 5),
                    direction: .northWest
                ),
                .rolledForArmour(coachID: .home, die: .d6, unmodified: 6),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectives: [
                        .second: .takeThemDown,
                    ]
                )
            )
        )

        // Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .second,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            )
                        )
                    ]
                ),
                .scoreUpdated(coachID: .away, increment: 2, total: 2),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        pl(.away, 0): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 6)
                        ),
                        pl(.away, 1): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 12)
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare run

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(6, 6)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 6),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaa.aaaa
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ..aaaa.aaaa
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
                    sq(6, 5),
                    sq(6, 6),
                    sq(6, 7),
                    sq(6, 8),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 6),
                    to: sq(6, 5),
                    direction: .north,
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 5),
                    ballID: 123
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 5),
                    to: sq(6, 6),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 6),
                    to: sq(6, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 7),
                    to: sq(6, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectives: [
                        .first: .getTheBall,
                    ]
                )
            )
        )

        // Claim objective

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
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 3),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        pl(.away, 0): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .pass,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 8)
                        ),
                        pl(.away, 1): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 12)
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare pass

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(6, 8)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 8),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(6, 12),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // Specify pass

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(5))
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 5),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(6, 8),
                    to: sq(6, 12),
                    angle: 180,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    playerSquare: sq(6, 12),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectives: [
                        .third: .moveTheBall,
                    ]
                )
            )
        )

        // Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .third,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 4),
                .earnedCleanSweep(coachID: .away),
                .scoreUpdated(coachID: .away, increment: 2, total: 6),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        pl(.home, 0): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(7, 6)
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(
            game.table.objectives.first == nil
        )
        #expect(
            game.table.objectives.second == nil
        )
        #expect(
            game.table.objectives.third == nil
        )
        #expect(
            game.table.coinFlipLoserHand == [
                ChallengeCard(
                    challenge: .takeThemDown,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .getTheBall,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .moveTheBall,
                    bonusPlay: .blitz
                ),
            ]
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == []
        )
        #expect(
            game.table.discards == []
        )
    }

    @Test func mustDiscardCardsYouAreHoldingAndDownToExactlyThreeCards() async throws {

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
                        coinFlipLoserTeamID: .undead
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .undead_wight,
                            state: .standing(square: sq(6, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .undead_ghoul,
                            state: .standing(square: sq(6, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 6)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(
                            challenge: .tieThemUp,
                            bonusPlay: .blitz
                        ),
                        ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .blitz
                        ),
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
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .blitz
                        ),
                        second: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        third: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        var (latestEvents, latestPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.smash))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(6, 6)
                ),
                .rolledForBlock(coachID: .away, results: [.smash]),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 6),
                    results: [.smash]
                )
            )
        )

        // Choose to reroll

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseOffensiveSpecialistSkillReroll
            ),
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(6), direction: direction(.northWest))
        )

        #expect(
            latestEvents == [
                .usedOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 6)
                ),
                .rolledForBlock(coachID: .away, results: [.smash]),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(6, 6),
                    to: sq(7, 6),
                    direction: .east,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(7, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(7, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .northWest
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(7, 6),
                    to: sq(6, 5),
                    direction: .northWest
                ),
                .rolledForArmour(coachID: .home, die: .d6, unmodified: 6),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectives: [
                        .second: .takeThemDown,
                    ]
                )
            )
        )

        // Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .second,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .tieThemUp,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .scoreUpdated(coachID: .away, increment: 2, total: 2),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        pl(.away, 0): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 6)
                        ),
                        pl(.away, 1): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 12)
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare run

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(6, 6)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 6),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaa.aaaa
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ..aaaa.aaaa
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
                    sq(6, 5),
                    sq(6, 6),
                    sq(6, 7),
                    sq(6, 8),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(6, 6),
                    to: sq(6, 5),
                    direction: .north,
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 5),
                    ballID: 123
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 5),
                    to: sq(6, 6),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 6),
                    to: sq(6, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 7),
                    to: sq(6, 8),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectives: [
                        .first: .getTheBall,
                    ]
                )
            )
        )

        // Claim objective

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
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .tieThemUp,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 3),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        pl(.away, 0): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .pass,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 8)
                        ),
                        pl(.away, 1): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(6, 12)
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare pass

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(6, 8)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 8),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(6, 12),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // Specify pass

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(5))
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 5),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(6, 8),
                    to: sq(6, 12),
                    angle: 180,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    playerSquare: sq(6, 12),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectives: [
                        .third: .moveTheBall,
                    ]
                )
            )
        )

        // Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .third,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .tieThemUp,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 4),
                .earnedCleanSweep(coachID: .away),
                .scoreUpdated(coachID: .away, increment: 2, total: 6),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .selectCardsToDiscardFromHand(cards: [
                    ChallengeCard(
                        challenge: .tieThemUp,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .spreadOut,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .takeThemDown,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .moveTheBall,
                        bonusPlay: .blitz
                    ),
                ])
            )
        )

        // Specify cards that aren't in hand

        #expect(throws: GameError("Invalid cards")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .selectCardsToDiscardFromHand(
                        cards: [
                            ChallengeCard(
                                challenge: .gangUp,
                                bonusPlay: .blitz
                            ),
                            ChallengeCard(
                                challenge: .makeARiskyPass,
                                bonusPlay: .blitz
                            ),
                        ]
                    )
                )
            )
        }

        // Specify too few cards

        #expect(throws: GameError("Invalid card count")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .selectCardsToDiscardFromHand(
                        cards: [
                            ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            ),
                        ]
                    )
                )
            )
        }

        // Specify too many cards

        #expect(throws: GameError("Invalid card count")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .selectCardsToDiscardFromHand(
                        cards: [
                            ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            ),
                            ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            ),
                            ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .blitz
                            ),
                        ]
                    )
                )
            )
        }

        // Specify valid cards

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectCardsToDiscardFromHand(
                    cards: [
                        ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        ),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .discardedCardFromHand(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .takeThemDown,
                        bonusPlay: .blitz
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .tieThemUp,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .updatedDiscards(top: .blitz, count: 1),
                .discardedCardFromHand(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .moveTheBall,
                        bonusPlay: .blitz
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .tieThemUp,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            )
                        ),
                    ]
                ),
                .updatedDiscards(top: .blitz, count: 2),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        pl(.home, 0): PromptValidDeclaringPlayer(
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ],
                            square: sq(7, 6)
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(
            game.table.objectives.first == nil
        )
        #expect(
            game.table.objectives.second == nil
        )
        #expect(
            game.table.objectives.third == nil
        )
        #expect(
            game.table.coinFlipLoserHand == [
                ChallengeCard(
                    challenge: .tieThemUp,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .spreadOut,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .getTheBall,
                    bonusPlay: .blitz
                ),
            ]
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == []
        )
        #expect(
            game.table.discards == [
                ChallengeCard(
                    challenge: .takeThemDown,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .moveTheBall,
                    bonusPlay: .blitz
                ),
            ]
        )
    }
}
