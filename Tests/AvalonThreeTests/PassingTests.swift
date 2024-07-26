//
//  PassingTests.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/25/24.
//

import Testing
@testable import AvalonThree

struct PassingTests {

    @Test func handingOffToAPlayerWithoutPassStat() async throws {

        // MARK: - Init

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
                            teamID: .human
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .necromantic
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .necromantic_zombie,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .necromantic_wraith,
                            state: .standing(square: sq(4, 5)),
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare handoff

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(4, 5),
                            distance: .handoff,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify handoff

        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: PlayerID(coachID: .away, index: 1))
            )
        )

        #expect(
            latestEvents == [
                .playerHandedOffBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(4, 5)
                ),
                .playerFailedCatch(playerID: PlayerID(coachID: .away, index: 1)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .south),
                .ballBounced(ballID: ballID, to: sq(4, 6)),
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
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

    @Test func passingToAPlayerWithoutPassStat() async throws {

        // MARK: - Init

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
                            teamID: .human
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .necromantic
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .necromantic_zombie,
                            state: .standing(square: sq(2, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .necromantic_wraith,
                            state: .standing(square: sq(4, 5)),
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(4, 5),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [6]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: PlayerID(coachID: .away, index: 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    die: .d6,
                    unmodified: 6
                ),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(4, 5)
                ),
                .playerFailedCatch(playerID: PlayerID(coachID: .away, index: 1)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .south),
                .ballBounced(ballID: ballID, to: sq(4, 6)),
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
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
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
