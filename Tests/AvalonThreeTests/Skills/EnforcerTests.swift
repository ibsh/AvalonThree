//
//  EnforcerTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/25/24.
//

import Testing
@testable import AvalonThree

struct EnforcerTests {

    @Test func resolveThreeDiceWithFinalInjury() async throws {

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
                        coinFlipLoserTeamID: .khorne
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .khorne_bloodseeker,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .khorne_marauder,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 6)),
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
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                        second: ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .blitz)
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
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
            randomizers: Randomizers(blockDie: block(.kerrunch, .tackle, .shove), d6: d6(4, 2), direction: direction(.east))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.shove, .kerrunch, .tackle]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .shove,
                    from: [.shove, .kerrunch, .tackle]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(2, 7),
                    to: sq(1, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: 123,
                    from: sq(1, 6),
                    to: sq(0, 6),
                    direction: .west,
                    reason: .shoved
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    reason: .followUp
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch,
                    from: [.kerrunch, .tackle]
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(0, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(0, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .east
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(0, 6),
                    to: sq(1, 6),
                    direction: .east
                ),
                .playerCaughtBouncingBall(
                    playerID: pl(.away, 0),
                    playerSquare: sq(1, 6),
                    ballID: 123
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 4
                ),
                .changedArmourResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [.kerrunch]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .tackle,
                    from: [.tackle]
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(1, 6)
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 2
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    playerSquare: sq(0, 6),
                    reason: .blocked
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

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
                            challenge: .freeUpTheBall,
                            bonusPlay: .blitz
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .freeUpTheBall,
                                bonusPlay: .blitz
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 2,
                    total: 2
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func resolveThreeDiceWithEarlyInjury() async throws {

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
                        coinFlipLoserTeamID: .khorne
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .khorne_bloodseeker,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .khorne_marauder,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 6)),
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
                            id: 123,
                            state: .held(playerID: pl(.home, 0))
                        ),
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        let (latestEvents, latestAddressedPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.miss, .smash, .smash), d6: d6(2), direction: direction(.south))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash, .smash, .miss]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash, .smash, .miss]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(2, 7),
                    to: sq(1, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(1, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(1, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .south
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(1, 6),
                    to: sq(1, 7),
                    direction: .south
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 2
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    playerSquare: sq(1, 6),
                    reason: .blocked
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash, .miss]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .miss,
                    from: [.miss]
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(2, 6)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
