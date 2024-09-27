//
//  ClawsTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/26/24.
//

import Testing
@testable import AvalonThree

struct ClawsTests {

    @Test func rollingLessThanSix() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
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
                        coinFlipLoserTeamID: .necromantic
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .necromantic_werewolf,
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
                    balls: [],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
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
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [5, 6]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForClaws(coachID: .away, result: 5),
                .rolledForBlock(coachID: .away, results: [.smash]),
                .selectedBlockDieResult(coachID: .away, result: .smash),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
                ),
                .rolledForArmour(coachID: .home, die: .d6, unmodified: 6),
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
                                playerID: pl(.away, 0),
                                actionID: .foul
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func rollingSix() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
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
                        coinFlipLoserTeamID: .necromantic
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .necromantic_werewolf,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .necromantic_zombie,
                            state: .standing(square: sq(2, 5)),
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
                    balls: [],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
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
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForClaws(coachID: .away, result: 6),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(2, 5),
                    to: sq(1, 6),
                    direction: .southWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }
}
