//
//  BomberTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/25/24.
//

import Testing
@testable import AvalonThree

struct BomberTests {

    @Test func bomberMakingRegularBlock() async throws {

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
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_fungusFlinga,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(4, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(3, 6)),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.miss, .kerrunch))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .blockActionSelectResult)

        // Choose block result

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(result: .kerrunch)
            ),
            randomizers: Randomizers(d6: d6(4), direction: direction(.southEast))
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch,
                    from: [.miss, .kerrunch]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(4, 5),
                    to: sq(3, 6),
                    direction: .southWest,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(4, 6),
                    to: sq(3, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 2),
                    from: sq(4, 7),
                    to: sq(3, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(3, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(3, 6)),
                .rolledForDirection(coachID: .away, direction: .southEast),
                .ballBounced(
                    ballID: 123,
                    from: sq(3, 6),
                    to: sq(4, 7),
                    direction: .southEast
                ),
                .playerCaughtBouncingBall(
                    playerID: pl(.away, 2),
                    playerSquare: sq(4, 7),
                    ballID: 123
                ),
                .rolledForArmour(coachID: .home, die: .d6, unmodified: 4),
                .changedArmourResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [.kerrunch]
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func bomberOutOfRange() async throws {

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
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_fungusFlinga,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 9)),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
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
        }
    }

    @Test func bomberHurlingBomb() async throws {

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
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_fungusFlinga,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(7, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 8)),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        var (latestEvents, latestAddressedPrompt) = try game.process(
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

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .blockActionSelectTarget)

        // Select block

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectTarget(target: pl(.home, 0))
            ),
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(2), direction: direction(.north))
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.smash]),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash]
                ),
                .playerThrewBomb(
                    playerID: pl(.away, 0),
                    from: sq(4, 5),
                    to: sq(7, 8),
                    angle: 135
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(7, 8),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(7, 8)),
                .rolledForDirection(coachID: .away, direction: .north),
                .ballBounced(
                    ballID: 123,
                    from: sq(7, 8),
                    to: sq(7, 7),
                    direction: .north
                ),
                .rolledForArmour(coachID: .home, die: .d6, unmodified: 2),
                .playerInjured(
                    playerID: pl(.home, 0),
                    playerSquare: sq(7, 8),
                    reason: .blocked
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func whenHurlingBombShoveBecomesMiss() async throws {

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
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_fungusFlinga,
                            state: .standing(square: sq(4, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 2),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(7, 9)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [:],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare block

        let (latestEvents, latestAddressedPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.shove), d6: d6(2), direction: direction(.north))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(4, 5)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.shove]
                ),
                .changedBlockResults(
                    from: [.shove],
                    to: [.miss],
                    modifications: [.playerThrewBomb]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .miss,
                    from: [.miss]
                ),
                .playerThrewBomb(
                    playerID: pl(.away, 0),
                    from: sq(4, 5),
                    to: sq(7, 8),
                    angle: 135
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(4, 5)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
