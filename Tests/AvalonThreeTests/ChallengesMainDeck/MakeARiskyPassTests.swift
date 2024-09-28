//
//  MakeARiskyPassTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/30/24.
//

import Testing
@testable import AvalonThree

struct MakeARiskyPassTests {

    @Test func notAvailableWhenPassUnsuccessful() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

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
                            spec: .orc_passer,
                            state: .standing(square: sq(8, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 6)),
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
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .makeARiskyPass,
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
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
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
                    playerSquare: sq(8, 6)
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
                            targetSquare: sq(2, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(1, 6)]
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]
        directionRandomizer.nextResults = [.west]

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
                    unmodified: 3
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 3,
                    modified: 2,
                    modifications: [
                        .longDistance,
                        .targetPlayerMarked,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(8, 6),
                    to: sq(2, 6),
                    angle: 270,
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
                    direction: .west
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west
                ),
                .playerCaughtBouncingBall(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
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
                                playerID: pl(.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func notAvailableWhenPassHasNoNegativeModifier() async throws {

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
                            spec: .orc_passer,
                            state: .standing(square: sq(5, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(0, 6)),
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
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .makeARiskyPass,
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
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
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
                    playerSquare: sq(5, 6)
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
                            targetSquare: sq(2, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]

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
                    unmodified: 3
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(2, 6),
                    angle: 270,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(2, 6),
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
                                playerID: pl(.away, 0),
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
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
                    playerActionsLeft: 2
                )
            )
        )

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func availableWhenModifiedPassSuccessful() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

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
                            spec: .orc_passer,
                            state: .standing(square: sq(8, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 6)),
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
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .makeARiskyPass,
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
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
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
                    playerSquare: sq(8, 6)
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
                            targetSquare: sq(2, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(1, 6)]
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [4]
        directionRandomizer.nextResults = [.west]

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
                .changedPassResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [
                        .longDistance,
                        .targetPlayerMarked,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(8, 6),
                    to: sq(2, 6),
                    angle: 270,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(2, 6),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.second]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
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
                            challenge: .makeARiskyPass,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .makeARiskyPass,
                                bonusPlay: .absoluteCarnage
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

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        #expect(game.table.objectives.first == nil)
        #expect(game.table.objectives.second == nil)
        #expect(game.table.objectives.third == nil)
        #expect(
            game.table.coinFlipLoserHand ==
            [ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)]
        )
    }

    @Test func notAvailableWhenHurlTeammateUnsuccessful() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

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
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
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
                            state: .held(playerID: pl(.away, 1))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .makeARiskyPass,
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
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: pl(.away, 0),
                    validTeammates: [
                        pl(.away, 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 4), sq(2, 4), sq(2, 3), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(2, 3), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .long, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(1, 10), sq(2, 11), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .short, obstructingSquares: [sq(1, 3), sq(2, 4), sq(2, 3), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .short, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 1), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 11), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 1), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(8, 4), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 3), distance: .long, obstructingSquares: [sq(9, 4), sq(9, 3), sq(8, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(7, 8), sq(8, 10), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 11), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 10), sq(8, 11), sq(9, 10), sq(7, 8)]),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d6Randomizer.nextResults = [1]
        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 1
                ),
                .playerFumbledTeammate(
                    playerID: pl(.away, 0),
                    in: sq(3, 6),
                    teammateID: pl(.away, 1),
                    ballID: 123
                ),
                .playerInjured(
                    playerID: pl(.away, 1),
                    in: sq(3, 6),
                    reason: .fumbled
                ),
                .ballCameLoose(ballID: 123, in: sq(3, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .west
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func notAvailableWhenHurlTeammateHasNoNegativeModifier() async throws {

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
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
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
                            state: .held(playerID: pl(.away, 1))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .makeARiskyPass,
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
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: pl(.away, 0),
                    validTeammates: [
                        pl(.away, 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 4), sq(2, 4), sq(2, 3), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(2, 3), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .long, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(1, 10), sq(2, 11), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .short, obstructingSquares: [sq(1, 3), sq(2, 4), sq(2, 3), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .short, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 1), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 11), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 1), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(8, 4), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 3), distance: .long, obstructingSquares: [sq(9, 4), sq(9, 3), sq(8, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(7, 8), sq(8, 10), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 11), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 10), sq(8, 11), sq(9, 10), sq(7, 8)]),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(3, 6),
                    to: sq(7, 6),
                    angle: 90
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    in: sq(7, 6)
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
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .mark
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
                    playerActionsLeft: 2
                )
            )
        )

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func availableWhenModifiedHurlTeammateSuccessful() async throws {

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
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        // We need a fake treeman who's better at throwing, so we can test
                        // modified rolls
                        Player(
                            id: pl(.away, 0),
                            spec: PlayerSpec(
                                move: .fixed(2),
                                block: 2,
                                pass: 4,
                                armour: 2,
                                skills: [.hulkingBrute, .hurlTeammate]
                            ),
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
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
                            state: .held(playerID: pl(.away, 1))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .makeARiskyPass,
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
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
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
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: pl(.away, 0),
                    validTeammates: [
                        pl(.away, 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 4), sq(2, 4), sq(2, 3), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(2, 3), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .long, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(1, 10), sq(2, 11), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .short, obstructingSquares: [sq(1, 3), sq(2, 4), sq(2, 3), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(1, 11), sq(1, 10), sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .short, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 1), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 11), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 1), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(8, 4), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 3), distance: .long, obstructingSquares: [sq(9, 4), sq(9, 3), sq(8, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(9, 4), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(7, 8), sq(8, 10), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 11), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 10), sq(8, 11), sq(9, 10), sq(7, 8)]),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(0, 4))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .changedHurlTeammateResult(
                    die: .d6,
                    unmodified: 5,
                    modified: 4,
                    modifications: [.obstructed]
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(3, 6),
                    to: sq(0, 4),
                    angle: 304
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    in: sq(0, 4)
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.second]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
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
                            challenge: .makeARiskyPass,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .makeARiskyPass,
                                bonusPlay: .absoluteCarnage
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

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .run
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        #expect(game.table.objectives.first == nil)
        #expect(game.table.objectives.second == nil)
        #expect(game.table.objectives.third == nil)
        #expect(
            game.table.coinFlipLoserHand ==
            [ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)]
        )
    }
}
