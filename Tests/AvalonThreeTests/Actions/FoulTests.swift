//
//  FoulTests.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/27/24.
//

import Testing
@testable import AvalonThree

struct FoulTests {

    @Test func notPromptedIfOnlyOneEligibleTarget() async throws {

        // Init

        let foulDieRandomizer = FoulDieRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .undead,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(5, 11)),
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare foul

        foulDieRandomizer.nextResults = [.gotThem]

        let (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
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
                        actionID: .foul
                    ),
                    isFree: false,
                    playerSquare: sq(5, 12)
                ),
                .rolledForFoul(coachID: .away, result: .gotThem),
                .playerFouled(
                    playerID: pl(.away, 0),
                    from: sq(5, 12),
                    to: sq(5, 11),
                    direction: .north,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(5, 11),
                    reason: .fouled
                ),
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
                            ],
                            square: sq(5, 12)
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func promptedIfMoreThanOneEligibleTarget() async throws {

        // Init

        let foulDieRandomizer = FoulDieRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .undead,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(4, 13)),
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare foul

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
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
                        actionID: .foul
                    ),
                    isFree: false,
                    playerSquare: sq(5, 12)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .foulActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    in: sq(5, 12),
                    validTargets: [
                        pl(.home, 0),
                        pl(.home, 1),
                    ]
                )
            )
        )

        // Specify foul

        foulDieRandomizer.nextResults = [.gotThem]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .foulActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForFoul(coachID: .away, result: .gotThem),
                .playerFouled(
                    playerID: pl(.away, 0),
                    from: sq(5, 12),
                    to: sq(5, 11),
                    direction: .north,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(5, 11),
                    reason: .fouled
                ),
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
                            ],
                            square: sq(5, 12)
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }
}
