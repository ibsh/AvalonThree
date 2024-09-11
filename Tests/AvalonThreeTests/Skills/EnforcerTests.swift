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

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .khorne
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .khorne_bloodseeker,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .khorne_marauder,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 6)),
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
                            state: .held(playerID: PlayerID(coachID: .home, index: 0))
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
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
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch, .tackle, .shove]
        d6Randomizer.nextResults = [4, 2]
        directionRandomizer.nextResults = [.east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.kerrunch, .tackle, .shove]),
                .selectedBlockDieResult(result: .shove),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(1, 6)
                ),
                .playerAssistedBlock(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6)
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(0, 6),
                    reason: .shoved
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(1, 6),
                    reason: .followUp
                ),
                .selectedBlockDieResult(result: .kerrunch),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .east),
                .ballBounced(ballID: ballID, to: sq(1, 6)),
                .playerCaughtBouncingBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .rolledForArmour(die: .d6, unmodified: 4),
                .changedArmourResult(die: .d6, modified: 3, modifications: [.kerrunch]),
                .selectedBlockDieResult(result: .tackle),
                .playerCannotTakeActions(playerID: PlayerID(coachID: .away, index: 0)),
                .rolledForArmour(die: .d6, unmodified: 2),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first, .second])
            )
        )

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .second),
                .scoreUpdated(coachID: .away, increment: 2),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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

    @Test func resolveThreeDiceWithEarlyInjury() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .khorne
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .khorne_bloodseeker,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .khorne_marauder,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 6)),
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
                            state: .held(playerID: PlayerID(coachID: .home, index: 0))
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
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
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.miss, .smash, .smash]
        d6Randomizer.nextResults = [2]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.miss, .smash, .smash]),
                .selectedBlockDieResult(result: .smash),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(1, 6)
                ),
                .playerAssistedBlock(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .south),
                .ballBounced(ballID: ballID, to: sq(1, 7)),
                .rolledForArmour(die: .d6, unmodified: 2),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .selectedBlockDieResult(result: .smash),
                .selectedBlockDieResult(result: .miss),
                .playerCannotTakeActions(playerID: PlayerID(coachID: .away, index: 0)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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
