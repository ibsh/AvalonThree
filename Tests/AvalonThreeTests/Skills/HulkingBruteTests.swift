//
//  HulkingBruteTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/26/24.
//

import Testing
@testable import AvalonThree

struct HulkingBruteTests {

    @Test func whenBlockingTackleBecomesKerrunch() async throws {

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
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .ogre
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .ogre_ogre,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 7)),
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
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
            randomizers: Randomizers(blockDie: block(.tackle, .miss))
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.tackle, .miss])
                ),
                .changedBlockResults(
                    from: BlockResults(dice: [.tackle, .miss]),
                    to: BlockResults(dice: [.kerrunch, .miss]),
                    modifications: [.playerIsHulkingBrute]
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionSelectResult(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(3, 6)
                    ),
                    results: BlockResults(dice: [.kerrunch, .miss])
                )
            )
        )
    }

    @Test func whenBlockingSmashBecomesKerrunch() async throws {

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
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .ogre
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .ogre_ogre,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
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
            randomizers: Randomizers(blockDie: block(.shove, .smash))
        )

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.shove, .smash])
                ),
                .changedBlockResults(
                    from: BlockResults(dice: [.shove, .smash]),
                    to: BlockResults(dice: [.shove, .kerrunch]),
                    modifications: [.playerIsHulkingBrute]
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionSelectResult(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(3, 6)
                    ),
                    results: BlockResults(dice: [.shove, .kerrunch])
                )
            )
        )
    }

    @Test func whenBlockedTackleBecomesMiss() async throws {

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
                        coinFlipWinnerTeamID: .ogre,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .ogre_ogre,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
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
            randomizers: Randomizers(
                ballID: ballID(123),
                blockDie: block(.tackle),
                direction: direction(.west)
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
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.tackle])
                ),
                .changedBlockResults(
                    from: BlockResults(dice: [.tackle]),
                    to: BlockResults(dice: [.miss]),
                    modifications: [
                        .opponentIsHulkingBrute
                    ]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.miss])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(3, 6),
                    direction: .east,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(2, 6)
                ), .turnEnded(coachID: .away),
                .playerCanTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(2, 6)
                ),
                .newBallAppeared(
                    ballID: 123,
                    ballSquare: sq(5, 7)
                ),
                .rolledForDirection(
                    coachID: .home,
                    direction: .west
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(5, 7),
                    to: sq(4, 7),
                    direction: .west
                ),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
