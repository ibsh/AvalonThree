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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare pass

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .passActionSelectTarget)

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(3), direction: direction(.west, .northWest))
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
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(2, 6)),
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
                .rolledForDirection(
                    coachID: .away,
                    direction: .northWest
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(1, 6),
                    to: sq(0, 5),
                    direction: .northWest
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func notAvailableWhenPassHasNoNegativeModifier() async throws {

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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare pass

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .passActionSelectTarget)

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(3))
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
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func availableWhenModifiedPassSuccessful() async throws {

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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare pass

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .passActionSelectTarget)

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(4), direction: direction(.west))
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
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .claimedObjective,
                .scoreUpdated,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        #expect(game.table.objectives.first == nil)
        #expect(game.table.objectives.second == nil)
        #expect(game.table.objectives.third == nil)
        #expect(
            game.table.coinFlipLoserHand ==
            [ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)]
        )
    }

    @Test func notAvailableWhenHurlTeammateUnsuccessful() async throws {

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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .hurlTeammateActionSelectTarget)

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(7, 6))
            ),
            randomizers: Randomizers(d6: d6(1), direction: direction(.west))
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
                    playerSquare: sq(3, 6),
                    teammateID: pl(.away, 1),
                    ballID: 123
                ),
                .playerInjured(
                    playerID: pl(.away, 1),
                    playerSquare: sq(3, 6),
                    reason: .fumbled
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(3, 6)),
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func notAvailableWhenHurlTeammateHasNoNegativeModifier() async throws {

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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .hurlTeammateActionSelectTarget)

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(7, 6))
            ),
            randomizers: Randomizers(d6: d6(5))
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
                    playerSquare: sq(7, 6)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        #expect(game.table.objectives.first == nil)
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)
        )
        #expect(game.table.objectives.third == nil)
        #expect(game.table.coinFlipLoserHand == [])
    }

    @Test func availableWhenModifiedHurlTeammateSuccessful() async throws {

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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .hurlTeammateActionSelectTarget)

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(0, 4))
            ),
            randomizers: Randomizers(d6: d6(5))
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
                    playerSquare: sq(0, 4)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .claimedObjective,
                .scoreUpdated,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        #expect(game.table.objectives.first == nil)
        #expect(game.table.objectives.second == nil)
        #expect(game.table.objectives.third == nil)
        #expect(
            game.table.coinFlipLoserHand ==
            [ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .absoluteCarnage)]
        )
    }
}
