//
//  CleanSweepTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/2/24.
//

import Testing
@testable import AvalonThree

struct CleanSweepTests {

    @Test func notAvailableWhenAllChallengesClaimedButFewerThanThreeWereAvailable() async throws {

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
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
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
                    )
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

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.smash])
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 6)
                    ),
                    results: BlockResults(dice: [.smash]),
                    maySelectResultToDecline: false
                )
            )
        )

        // Choose to reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
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
                    playerID: pl(.away, 0),
                    from: sq(6, 6),
                    to: sq(7, 6),
                    direction: .east,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(6, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(6, 12),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 6)
                    ),
                    maxDistance: 6,
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

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [0],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 0,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 1),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(6, 8),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .pass,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(6, 12),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare pass

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .passActionSelectTarget(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 8)
                    ),
                    validTargets: [
                        PassTarget(
                            targetPlayer: PromptBoardPlayer(
                                id: pl(.away, 1),
                                square: sq(6, 12)
                            ),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [2],
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 2)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 2,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: nil
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 2),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 0),
                            square: sq(7, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(game.table.coinFlipLoserScore == 2)
        #expect(game.table.coinFlipWinnerScore == 0)
    }

    @Test func notAvailableWhenAllThreeChallengesEarnedButNotAllClaimed() async throws {

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
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
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
                    )
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

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.smash])
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 6)
                    ),
                    results: BlockResults(dice: [.smash]),
                    maySelectResultToDecline: false
                )
            )
        )

        // Choose to reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
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
                    playerID: pl(.away, 0),
                    from: sq(6, 6),
                    to: sq(7, 6),
                    direction: .east,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [1],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: WrappedObjective(challenge: .takeThemDown, value: 2),
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 1,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 2, total: 2),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(6, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(6, 12),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 6)
                    ),
                    maxDistance: 6,
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

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [0],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Decline objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineToClaimObjective
            )
        )

        #expect(
            latestEvents == [
                .declinedObjectives(
                    coachID: .away,
                    indices: [0],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(6, 8),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .pass,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(6, 12),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare pass

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .passActionSelectTarget(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 8)
                    ),
                    validTargets: [
                        PassTarget(
                            targetPlayer: PromptBoardPlayer(
                                id: pl(.away, 1),
                                square: sq(6, 12)
                            ),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [2],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 2)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 2,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: nil
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 3),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 0),
                            square: sq(7, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(game.table.coinFlipLoserScore == 3)
        #expect(game.table.coinFlipWinnerScore == 0)
    }

    @Test func earnedWhenAllThreeChallengesClaimed() async throws {

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
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
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
                    )
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

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.smash])
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 6)
                    ),
                    results: BlockResults(dice: [.smash]),
                    maySelectResultToDecline: false
                )
            )
        )

        // Choose to reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
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
                    playerID: pl(.away, 0),
                    from: sq(6, 6),
                    to: sq(7, 6),
                    direction: .east,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [1],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: WrappedObjective(challenge: .takeThemDown, value: 2),
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 1,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 2, total: 2),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 6)
                    ),
                    maxDistance: 6,
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

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [0],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .getTheBall, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 0,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 3),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(6, 8),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .pass,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(6, 12),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare pass

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .passActionSelectTarget(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 8)
                    ),
                    validTargets: [
                        PassTarget(
                            targetPlayer: PromptBoardPlayer(
                                id: pl(.away, 1),
                                square: sq(6, 12)
                            ),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [2],
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 2)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 2,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: nil
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                        .open(
                            card: ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .absoluteCarnage
                            )
                        ),
                    ],
                    active: []
                ),
                .scoreUpdated(coachID: .away, increment: 1, total: 4),
                .earnedCleanSweep(coachID: .away),
                .scoreUpdated(coachID: .away, increment: 2, total: 6),
                .turnEnded(coachID: .away),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 0),
                            square: sq(7, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(game.table.coinFlipLoserScore == 6)
        #expect(game.table.coinFlipWinnerScore == 0)
    }
}
