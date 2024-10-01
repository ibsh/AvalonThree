//
//  HailMaryPassTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct HailMaryPassTests {

    @Test func usedSuccessfullyPreDeclaration() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(9, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Try to declare pass without bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
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
        }

        // Declare pass

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: [.hailMaryPass]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionSpecifyTarget)

        // Specify pass

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 4
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [.longDistance]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(0, 6),
                    to: sq(9, 6),
                    angle: 90,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(9, 6),
                    ballID: 123
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .hailMaryPass
                    )
                ),
                .updatedDiscards(
                    top: .hailMaryPass,
                    count: 1
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAndFailedPreDeclaration() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(9, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare pass

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: [.hailMaryPass]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionSpecifyTarget)

        // Specify pass

        d6Randomizer.nextResults = [3]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 3
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 3,
                    modified: 2,
                    modifications: [.longDistance]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(0, 6),
                    to: sq(9, 6),
                    angle: 90,
                    ballID: 123
                ),
                .playerFailedCatch(
                    playerID: pl(.away, 1),
                    in: sq(9, 6),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, in: sq(9, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .south
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(9, 6),
                    to: sq(9, 7),
                    direction: .south
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .hailMaryPass
                    )
                ),
                .updatedDiscards(
                    top: .hailMaryPass,
                    count: 1
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAndFumbledPreDeclaration() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(9, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare pass

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: [.hailMaryPass]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionSpecifyTarget)

        // Specify pass

        d6Randomizer.nextResults = [2]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 2
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 2,
                    modified: 1,
                    modifications: [.longDistance]
                ),
                .playerFumbledBall(
                    playerID: pl(.away, 0),
                    in: sq(0, 6),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, in: sq(0, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .south
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(0, 6),
                    to: sq(0, 7),
                    direction: .south
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .hailMaryPass
                    )
                ),
                .updatedDiscards(
                    top: .hailMaryPass,
                    count: 1
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declinedPostDeclaration() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_runner,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare pass

        var (latestEvents, latestPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionEligibleForHailMaryPassBonusPlay)

        // Decline bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionDeclineHailMaryPassBonusPlay
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionSpecifyTarget)

        // Specify pass

        d6Randomizer.nextResults = [3]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .rolledForPass,
                .playerPassedBall,
                .playerCaughtPass,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedSuccessfullyPostDeclarationForAReallyEasyPass() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_runner,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare pass

        var (latestEvents, latestPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionEligibleForHailMaryPassBonusPlay)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseHailMaryPassBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionSpecifyTarget)

        // Specify pass

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(.away, 1)
                )
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
                    from: sq(0, 6),
                    to: sq(2, 6),
                    angle: 90,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(2, 6),
                    ballID: 123
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .hailMaryPass
                    )
                ),
                .updatedDiscards(
                    top: .hailMaryPass,
                    count: 1
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func usedAndFailedPostDeclarationForAReallyEasyPass() async throws {

        // Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .darkElf_runner,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare pass

        var (latestEvents, latestPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionEligibleForHailMaryPassBonusPlay)

        // Use bonus play

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseHailMaryPassBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .passActionSpecifyTarget)

        // Specify pass

        d6Randomizer.nextResults = [3]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 3
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(0, 6),
                    to: sq(2, 6),
                    angle: 90,
                    ballID: 123
                ),
                .playerFailedCatch(
                    playerID: pl(.away, 1),
                    in: sq(2, 6),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, in: sq(2, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .south
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(2, 6),
                    to: sq(2, 7),
                    direction: .south
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .hailMaryPass
                    )
                ),
                .updatedDiscards(
                    top: .hailMaryPass,
                    count: 1
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
