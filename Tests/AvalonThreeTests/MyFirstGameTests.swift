//
//  MyFirstGameTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/19/24.
//

import Foundation
import Testing
@testable import AvalonThree

struct MyFirstGameTests {

    @Test func testMyFirstGame() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let coachIDRandomizer = CoachIDRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let d8Randomizer = D8RandomizerDouble()
        let deckRandomizer = DeckRandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()
        let foulDieRandomizer = FoulDieRandomizerDouble()
        let trapdoorRandomizer = TrapdoorRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        var game = Game(
            phase: .config(Config()),
            previousPrompt: nil,
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                coachID: coachIDRandomizer,
                d6: d6Randomizer,
                d8: d8Randomizer,
                deck: deckRandomizer,
                direction: directionRandomizer,
                foulDie: foulDieRandomizer,
                trapdoor: trapdoorRandomizer
            ),
            uuidProvider: uuidProvider
        )

        coachIDRandomizer.nextResult = .home

        // MARK: - Begin

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            )
        )

        #expect(
            latestEvents == [
                .flippedCoin(coachID: .home)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .specifyBoardSpec(
                    boardSpecIDs: [
                        .whiteWolfHolm,
                        .altdorfOldTown,
                        .barakVarrFoundry,
                        .ghrondGridiron,
                        .oghamStoneCrush,
                        .bilbaliHarbor,
                    ]
                )
            )
        )

        // MARK: - Second coach config

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyBoardSpec(boardSpecID: .whiteWolfHolm)
            )
        )

        #expect(
            latestEvents == [
                .specifiedBoardSpec(boardSpecID: .whiteWolfHolm)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .specifyChallengeDeck(
                    challengeDeckIDs: [
                        .shortStandard,
                        .shortRandomised,
                        .longStandard,
                        .longRandomised,
                    ]
                )
            )
        )

        // MARK: - Second coach config

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyChallengeDeck(challengeDeckID: .shortStandard)
            )
        )

        #expect(
            latestEvents == [
                .specifiedChallengeDeck(challengeDeckID: .shortStandard)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .specifyRookieBonusRecipient(
                    rookieBonusRecipientIDs: [
                        .noOne,
                        .coinFlipLoser,
                        .coinFlipWinner,
                    ]
                )
            )
        )

        // MARK: - Second coach config

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyRookieBonusRecipient(rookieBonusRecipientID: .noOne)
            )
        )


        #expect(
            latestEvents == [
                .specifiedRookieBonusRecipient(rookieBonusRecipientID: .noOne)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .specifyCoinFlipWinnerTeam(
                    teamIDs: [
                        .blackOrc,
                        .chaos,
                        .darkElf,
                        .dwarf,
                        .elf,
                        .goblin,
                        .halfling,
                        .human,
                        .khorne,
                        .lizardmen,
                        .necromantic,
                        .noble,
                        .nurgle,
                        .ogre,
                        .orc,
                        .skaven,
                        .snotling,
                        .undead,
                        .woodElf,
                    ]
                )
            )
        )

        // MARK: - Second coach config

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyCoinFlipWinnerTeam(teamID: .skaven)
            )
        )

        #expect(
            latestEvents == [
                .specifiedCoinFlipWinnerTeam(teamID: .skaven)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .specifyCoinFlipLoserTeam(
                    teamIDs: [
                        .blackOrc,
                        .chaos,
                        .darkElf,
                        .dwarf,
                        .elf,
                        .goblin,
                        .halfling,
                        .human,
                        .khorne,
                        .lizardmen,
                        .necromantic,
                        .noble,
                        .nurgle,
                        .ogre,
                        .orc,
                        .skaven,
                        .snotling,
                        .undead,
                        .woodElf,
                    ]
                )
            )
        )

        // MARK: - First coach config

        deckRandomizer.nextResult = Array(ChallengeCard.standardShortDeck.prefix(5))

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyCoinFlipLoserTeam(teamID: .human)
            )
        )

        #expect(
            latestEvents == [
                .specifiedCoinFlipLoserTeam(teamID: .human),
                .tableWasSetUp(
                    playerConfigs: [
                        PlayerConfig(
                            id: PlayerID(coachID: .away, index: 0),
                            specID: .human_lineman
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .away, index: 1),
                            specID: .human_lineman
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .away, index: 2),
                            specID: .human_lineman
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .away, index: 3),
                            specID: .human_passer
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .away, index: 4),
                            specID: .human_catcher
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .away, index: 5),
                            specID: .human_blitzer
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .home, index: 0),
                            specID: .skaven_lineman
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .home, index: 1),
                            specID: .skaven_lineman
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .home, index: 2),
                            specID: .skaven_lineman
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .home, index: 3),
                            specID: .skaven_passer
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .home, index: 4),
                            specID: .skaven_gutterRunner
                        ),
                        PlayerConfig(
                            id: PlayerID(coachID: .home, index: 5),
                            specID: .skaven_blitzer
                        ),
                    ],
                    deck: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .stepAside),
                        ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .blitz),
                        ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .intervention),
                        ChallengeCard(challenge: .gangUp, bonusPlay: .inspiration),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: []
                ),
                .dealtNewObjective(coachID: .away, objectiveID: .first),
                .dealtNewObjective(coachID: .away, objectiveID: .second),
                .dealtNewObjective(coachID: .away, objectiveID: .third),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .arrangePlayers(playerConfigs: [
                    PlayerConfig(
                        id: PlayerID(coachID: .away, index: 0),
                        specID: .human_lineman
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .away, index: 1),
                        specID: .human_lineman
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .away, index: 2),
                        specID: .human_lineman
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .away, index: 3),
                        specID: .human_passer
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .away, index: 4),
                        specID: .human_catcher
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .away, index: 5),
                        specID: .human_blitzer
                    ),
                ])
            )
        )

        // MARK: - First coach arrange players

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .arrangePlayers(
                    playerPositions: [
                        sq(0, 0),
                        sq(1, 0),
                        sq(4, 0),
                        sq(6, 0),
                        sq(9, 0),
                        sq(10, 0)
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(0, 0),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 0),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 0),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 0),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 4),
                    square: sq(9, 0),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 5),
                    square: sq(10, 0),
                    reason: .reserves
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .arrangePlayers(playerConfigs: [
                    PlayerConfig(
                        id: PlayerID(coachID: .home, index: 0),
                        specID: .skaven_lineman
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .home, index: 1),
                        specID: .skaven_lineman
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .home, index: 2),
                        specID: .skaven_lineman
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .home, index: 3),
                        specID: .skaven_passer
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .home, index: 4),
                        specID: .skaven_gutterRunner
                    ),
                    PlayerConfig(
                        id: PlayerID(coachID: .home, index: 5),
                        specID: .skaven_blitzer
                    ),
                ])
            )
        )

        // MARK: - Second coach arrange players

        let newBallID = UUID()
        uuidProvider.nextResults = [newBallID]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .arrangePlayers(
                    playerPositions: [
                        sq(2, 14),
                        sq(3, 14),
                        sq(4, 14),
                        sq(6, 14),
                        sq(7, 14),
                        sq(8, 14)
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(2, 14),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 1),
                    square: sq(3, 14),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 2),
                    square: sq(4, 14),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 3),
                    square: sq(6, 14),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 4),
                    square: sq(7, 14),
                    reason: .reserves
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 5),
                    square: sq(8, 14),
                    reason: .reserves
                ),
                .newBallAppeared(ballID: newBallID, square: sq(5, 7)),
                .gameStarted
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
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 3),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        // MARK: - First coach declare turn 1 action 1

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 2),
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
                        playerID: PlayerID(coachID: .away, index: 2),
                        actionID: .run
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 2),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ..aaaa.aa..
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ..aaaa.aa..
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa...
                        aaaaaaaaaa.
                        .aaaaaaaaa.
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - First coach specify turn 1 action 1

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(4, 1),
                    sq(4, 2),
                    sq(4, 3),
                    sq(4, 4),
                    sq(4, 5),
                    sq(4, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 1),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 2),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 3),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 4),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 5),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 2),
                    square: sq(4, 6),
                    reason: .run
                ),
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
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 3),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - First coach declare turn 1 action 2

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 3),
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
                        playerID: PlayerID(coachID: .away, index: 3),
                        actionID: .run
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 3),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ..aaaaaaa..
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaa.aaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ..aaaaaaa..
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaa.aaaaa.
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - First coach specify turn 1 action 2

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(6, 1),
                    sq(6, 2),
                    sq(6, 3),
                    sq(6, 4),
                    sq(6, 5),
                    sq(6, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 1),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 2),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 3),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 4),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 5),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 3),
                    square: sq(6, 6),
                    reason: .run
                ),
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
                                playerID: PlayerID(coachID: .away, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - First coach declare turn 1 action 3

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
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
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .run
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 1),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        .aaaaaaa...
                        aaaaaaaa...
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaa.a.a...
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        .aaaaaaa...
                        aaaaaaaa...
                        aaaaaaaa...
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaa...
                        aaaa.a.a...
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - First coach specify turn 1 action 3

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(1, 1),
                    sq(1, 2),
                    sq(0, 3),
                    sq(0, 4),
                    sq(1, 5),
                    sq(1, 6),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 1),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 2),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(0, 3),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(0, 4),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 5),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(1, 6),
                    reason: .run
                ),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 3),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 5),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }
}
