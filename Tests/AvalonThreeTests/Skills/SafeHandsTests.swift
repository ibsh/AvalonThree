//
//  SafeHandsTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Testing
@testable import AvalonThree

struct SafeHandsTests {

    @Test func selectsDirectionWhenKnockedDown() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .lizardmen,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(3, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .lizardmen_skinkRunner,
                            state: .standing(square: sq(3, 4)),
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
            )
        )

        // Declare block

        var (latestEvents, latestPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.kerrunch))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .ballCameLoose,
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .blockActionSelectSafeHandsLooseBallDirection(
                    playerID: pl(.home, 0),
                    playerSquare: sq(3, 4),
                    directions: [
                        .north,
                        .northEast,
                        .east,
                        .southEast,
                        .south,
                        .southWest,
                    ]
                )
            )
        )

        // Choose loose ball direction

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionSelectSafeHandsLooseBallDirection(direction: .east)
            ),
            randomizers: Randomizers(d6: d6(6))
        )

        #expect(
            latestEvents == [
                .selectedLooseBallDirection(
                    playerID: pl(.home, 0),
                    playerSquare: sq(3, 4),
                    direction: .east
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(3, 4),
                    to: sq(4, 4),
                    direction: .east
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 6
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
