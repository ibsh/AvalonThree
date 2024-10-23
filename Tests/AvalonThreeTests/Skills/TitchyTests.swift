//
//  TitchyTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/27/24.
//

import Testing
@testable import AvalonThree

struct TitchyTests {

    @Test func playersCanEndRunActionsAdjacentToThisGuy() async throws {

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
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .ogre_gnoblar,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(3, 6)
                    ),
                    maxDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        ...aaaaaaa.
                        ...aaaaaaa.
                        ...aaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaaa.
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        ...aaaaa...
                        ..aaaaaaaa.
                        ..aaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
                    sq(3, 7),
                    sq(3, 8),
                    sq(2, 8),
                    sq(1, 7),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 6),
                    to: sq(3, 7),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 7),
                    to: sq(3, 8),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 8),
                    to: sq(2, 8),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(2, 8),
                    to: sq(1, 7),
                    direction: .northWest,
                    reason: .run
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func ifPlayersRunAdjacentToThisGuyTheyCantCarryOn() async throws {

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
                        coinFlipWinnerTeamID: .orc,
                        coinFlipLoserTeamID: .human
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .orc_lineman,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(3, 6)
                    ),
                    maxDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        ...aaaaaaa.
                        ...aaaaaaa.
                        ...aaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaaa.
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        ...aaaaa...
                        ...aaaaaaa.
                        ...aaaaaaa.
                        ...aaaaaaa.
                        aaaaaaaaaa.
                        aaaaaaaaaa.
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // Select run

        #expect(throws: GameError("Invalid intermediate square")) {
            (latestEvents, latestAddressedPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .runActionSelectSquares(squares: [
                        sq(3, 7),
                        sq(3, 8),
                        sq(2, 8),
                        sq(1, 7),
                        sq(2, 8),
                    ])
                )
            )
        }
    }

    @Test func whenBlockingTackleBecomesMiss() async throws {

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
                            spec: .ogre_gnoblar,
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
            randomizers: Randomizers(blockDie: block(.tackle))
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
                    results: BlockResults(dice: [.tackle])
                ),
                .changedBlockResults(
                    from: BlockResults(dice: [.tackle]),
                    to: BlockResults(dice: [.miss]),
                    modifications: [.playerIsTitchy]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.miss])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(3, 6)
                ),
                .turnEnded(coachID: .away),
                .playerCanTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(3, 6)
                ),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
