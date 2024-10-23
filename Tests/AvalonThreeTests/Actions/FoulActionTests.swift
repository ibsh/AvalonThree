//
//  FoulTests.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/27/24.
//

import Testing
@testable import AvalonThree

struct FoulActionTests {

    @Test func notPromptedIfOnlyOneEligibleTarget() async throws {

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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        let (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.gotThem))
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
                    playerSquare: sq(5, 11),
                    reason: .fouled
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 12),
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
    }

    @Test func promptedIfMoreThanOneEligibleTarget() async throws {

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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .foulActionSelectTarget(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(5, 12)
                    ),
                    validTargets: [
                        PromptBoardPlayer(
                            id: pl(.home, 0),
                            square: sq(5, 11)
                        ),
                        PromptBoardPlayer(
                            id: pl(.home, 1),
                            square: sq(4, 13)
                        ),
                    ]
                )
            )
        )

        // Select foul

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .foulActionSelectTarget(target: pl(.home, 0))
            ),
            randomizers: Randomizers(foulDie: foul(.gotThem))
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
                    playerSquare: sq(5, 11),
                    reason: .fouled
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 12),
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
    }
}
