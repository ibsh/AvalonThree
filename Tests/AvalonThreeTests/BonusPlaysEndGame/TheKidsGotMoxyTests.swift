//
//  TheKidsGotMoxyTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct TheKidsGotMoxyTests {

    @Test func used() async throws {

        // Init

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .theKidsGotMoxy),
                    ],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
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
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .blockActionEligibleForTheKidsGotMoxyBonusPlay)

        // Use bonus play

        blockDieRandomizer.nextResults = [.miss, .kerrunch, .shove]
        d6Randomizer.nextResults = [5]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseTheKidsGotMoxyBonusPlay
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .activatedBonusPlay,
                .rolledForBlock,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .blockActionSelectResult)

        // Choose block result

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(result: .kerrunch)
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch,
                    from: [.miss, .kerrunch, .shove]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
                    reason: PlayerFallDownReason.blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 5
                ),
                .changedArmourResult(
                    die: .d6,
                    unmodified: 5,
                    modified: 4,
                    modifications: [.kerrunch]
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .theKidsGotMoxy
                    )
                ),
                .updatedDiscards(
                    top: .theKidsGotMoxy,
                    count: 1
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }

    @Test func declined() async throws {

        // Init

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .theKidsGotMoxy),
                    ],
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
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
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
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .blockActionEligibleForTheKidsGotMoxyBonusPlay)

        // Decline bonus play

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [5]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineTheKidsGotMoxyBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
                    reason: PlayerFallDownReason.blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 5
                ),
            ]
        )

        #expect(latestPrompt?.coachID == .away)
        #expect(latestPrompt?.payload.case == .declarePlayerAction)
    }
}
