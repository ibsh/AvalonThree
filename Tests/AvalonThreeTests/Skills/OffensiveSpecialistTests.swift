//
//  OffensiveSpecialistTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/26/24.
//

import Testing
@testable import AvalonThree

struct OffensiveSpecialistTests {

    @Test func selectResultRatherThanRerolling() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        )
                    ],
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch, .miss]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.kerrunch, .miss]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: PlayerID(coachID: .away, index: 0),
                    results: [.kerrunch, .miss]
                )
            )
        )

        // MARK: - Choose block result rather than reroll

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineOffensiveSpecialistSkillReroll(result: .kerrunch)
            )
        )

        #expect(
            latestEvents == [
                .declinedOffensiveSpecialistSkillReroll(playerID: PlayerID(coachID: .away, index: 0)),
                .selectedBlockDieResult(coachID: .away, result: .kerrunch),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(2, 6)
                ),
                .playerAssistedBlock(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(2, 6)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .rolledForArmour(die: .d6, unmodified: 5),
                .changedArmourResult(die: .d6, modified: 4, modifications: [.kerrunch]),
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
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .foul
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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

    @Test func selectToReroll() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        )
                    ],
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove, .miss]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.shove, .miss]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: PlayerID(coachID: .away, index: 0),
                    results: [.shove, .miss]
                )
            )
        )

        // MARK: - Choose to reroll

        blockDieRandomizer.nextResults = [.smash, .miss]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseOffensiveSpecialistSkillReroll
            )
        )

        #expect(
            latestEvents == [
                .usedOffensiveSpecialistSkillReroll(playerID: PlayerID(coachID: .away, index: 0)),
                .rolledForBlock(results: [.smash, .miss]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSelectResult(
                    playerID: PlayerID(coachID: .away, index: 0),
                    results: [.smash, .miss]
                )
            )
        )

        // MARK: - Choose block result

        d6Randomizer.nextResults = [3]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(result: .smash)
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(coachID: .away, result: .smash),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(2, 6)
                ),
                .playerAssistedBlock(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(2, 6)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .rolledForArmour(die: .d6, unmodified: 3),
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
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .foul
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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
}
