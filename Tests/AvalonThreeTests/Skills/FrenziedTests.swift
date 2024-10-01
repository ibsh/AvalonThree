//
//  FrenziedTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/25/24.
//

import Testing
@testable import AvalonThree

struct FrenziedTests {

    @Test func freeBlockActionDeclined() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .dwarf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .dwarf_trollslayer,
                            state: .standing(square: sq(3, 6)),
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
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare mark

        var (latestEvents, latestPrompt) = try game.process(
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
                message: .markActionSpecifySquares(
                    squares: [
                        sq(2, 6)
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForFrenziedSkillBlockAction)

        // Decline block

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineFrenziedSkillBlockAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declinedFrenziedSkillBlockAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func freeBlockActionTaken() async throws {

        // Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .dwarf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .dwarf_trollslayer,
                            state: .standing(square: sq(3, 6)),
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
                            state: .held(playerID: pl(.home, 0))
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare mark

        var (latestEvents, latestPrompt) = try game.process(
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
                message: .markActionSpecifySquares(
                    squares: [
                        sq(2, 6)
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForFrenziedSkillBlockAction)

        // Take free block

        blockDieRandomizer.nextResults = [.shove]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useFrenziedSkillBlockAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .blockActionEligibleForFollowUp)

        // Follow up

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseFollowUp
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)

        // Make sure we still have two actions in spite of the block

        // Declare sidestep

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .sidestep
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
        #expect(latestPrompt?.payload.case == .sidestepActionSpecifySquare)

        // Specify sidestep

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .sidestepActionSpecifySquare(square: sq(2, 6))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)

        // Declare run

        (latestEvents, latestPrompt) = try game.process(
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
                message: .runActionSpecifySquares(squares: [
                    sq(3, 6),
                    sq(4, 6)
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestPrompt?.coachID == .home)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func canPreventEarningTieThemUp() async throws {

        // Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .dwarf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .dwarf_trollslayer,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .dwarf_lineman,
                            state: .standing(square: sq(1, 4)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 2),
                            spec: .human_lineman,
                            state: .standing(square: sq(1, 5)),
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
                            state: .loose(square: sq(0, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .tieThemUp,
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
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // Declare mark

        var (latestEvents, latestPrompt) = try game.process(
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
                message: .markActionSpecifySquares(
                    squares: [
                        sq(2, 6)
                    ]
                )
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .eligibleForFrenziedSkillBlockAction)

        var otherGame = game

        // Take free block and lose "tie them up"

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useFrenziedSkillBlockAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .blockActionSpecifyTarget)

        // Specify block

        blockDieRandomizer.nextResults = [.miss]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerCannotTakeActions,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)

        // Decline free block and earn "tie them up"

        (latestEvents, latestPrompt) = try otherGame.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineFrenziedSkillBlockAction
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declinedFrenziedSkillBlockAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .earnedObjective)
    }
}
