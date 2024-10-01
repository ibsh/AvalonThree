//
//  RegenerateTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Testing
@testable import AvalonThree

struct RegenerateTests {

    @Test func multipleProneSkeletons() async throws {

        // Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

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
                            state: .standing(square: sq(10, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .undead_skeleton,
                            state: .prone(
                                square: sq(4, 4)
                            ),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(8, 6)),
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: ballIDProvider
        )

        // Declare run

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
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
        #expect(latestPrompt?.payload.case == .runActionSpecifySquares)

        // Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(10, 9),
                        sq(9, 8),
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)

        // Declare mark

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
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
        #expect(latestPrompt?.payload.case == .markActionSpecifySquares)

        // Specify mark

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(8, 7)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)

        // Declare block

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [4]
        let newBallID = 123
        ballIDProvider.nextResults = [newBallID]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPrompt) = try game.process(
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
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .rolledForArmour,
                .turnEnded,
                .newBallAppeared,
                .rolledForDirection,
                .ballBounced,
                .playerCaughtBouncingBall,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForRegenerationSkillStandUpAction)

        // Decline first standup

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineRegenerationSkillStandUpAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declinedRegenerationSkillStandUpAction,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .eligibleForRegenerationSkillStandUpAction)

        // Accept second standup

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useRegenerationSkillStandUpAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .playerStoodUp,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
