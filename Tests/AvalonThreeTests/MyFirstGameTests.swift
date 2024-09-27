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
        let playerNumberRandomizer = PlayerNumberRandomizerDouble()
        let trapdoorRandomizer = TrapdoorRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

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
                playerNumber: playerNumberRandomizer,
                trapdoor: trapdoorRandomizer
            ),
            ballIDProvider: ballIDProvider
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
                        .season1Board1,
                        .season1Board2,
                        .season2Board1,
                        .season2Board2,
                        .season3Board1,
                        .season3Board2,
                    ]
                )
            )
        )

        // MARK: - Second coach config

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyBoardSpec(boardSpecID: .season1Board1)
            )
        )

        #expect(
            latestEvents == [
                .specifiedBoardSpec(
                    coachID: .home,
                    boardSpecID: .season1Board1,
                    boardSpec: .season1Board1
                )
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
                .specifiedChallengeDeck(coachID: .home, challengeDeckID: .shortStandard)
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
                .specifiedRookieBonusRecipient(coachID: .home, recipientCoachID: nil)
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
                .specifiedTeam(coachID: .home, teamID: .skaven)
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

        playerNumberRandomizer.nextResults = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyCoinFlipLoserTeam(teamID: .human)
            )
        )

        #expect(
            latestEvents == [
                .specifiedTeam(
                    coachID: .away,
                    teamID: TeamID.human
                ),
                .startingHandWasSetUp(
                    coachID: .home,
                    hand: []
                ),
                .startingHandWasSetUp(
                    coachID: .away,
                    hand: []
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 0),
                    number: 1
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 1),
                    number: 2
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 2),
                    number: 3
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 3),
                    number: 4
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 4),
                    number: 5
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 5),
                    number: 6
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 0),
                    number: 7
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 1),
                    number: 8
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 2),
                    number: 9
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 3),
                    number: 10
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 4),
                    number: 11
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 5),
                    number: 12
                ),
                .startingPlayersWereSetUp(
                    coachID: .home,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.home, 0),
                            specID: PlayerSpecID
                                .skaven_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 4,
                                armour: 4,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 1),
                            specID: PlayerSpecID
                                .skaven_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 4,
                                armour: 4,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 2),
                            specID: PlayerSpecID
                                .skaven_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 4,
                                armour: 4,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 3),
                            specID: PlayerSpecID
                                .skaven_passer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 3,
                                armour: 4,
                                skills: [
                                    PlayerSpec.Skill
                                        .handlingSkills
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 4),
                            specID: PlayerSpecID
                                .skaven_gutterRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(9),
                                block: 1,
                                pass: 4,
                                armour: 5,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 5),
                            specID: PlayerSpecID
                                .skaven_blitzer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 5,
                                armour: 3,
                                skills: [
                                    PlayerSpec.Skill
                                        .offensiveSpecialist
                                ]
                            )
                        ),
                    ]
                ),
                .startingPlayersWereSetUp(
                    coachID: .away,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.away, 0),
                            specID: PlayerSpecID
                                .human_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 4,
                                armour: 3,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 1),
                            specID: PlayerSpecID
                                .human_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 4,
                                armour: 3,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 2),
                            specID: PlayerSpecID
                                .human_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 4,
                                armour: 3,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 3),
                            specID: PlayerSpecID
                                .human_passer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 3,
                                armour: 3,
                                skills: [
                                    PlayerSpec.Skill
                                        .handlingSkills
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 4),
                            specID: PlayerSpecID
                                .human_catcher,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 5,
                                skills: [
                                    PlayerSpec.Skill
                                        .catchersInstincts
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 5),
                            specID: PlayerSpecID
                                .human_blitzer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 4,
                                armour: 3,
                                skills: [
                                    PlayerSpec.Skill
                                        .offensiveSpecialist
                                ]
                            )
                        ),
                    ]
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .second,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveID: .third,
                    objective: .freeUpTheBall
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
                    count: 2
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .arrangePlayers(
                    playerIDs: [
                        pl(.away, 0),
                        pl(.away, 1),
                        pl(.away, 2),
                        pl(.away, 3),
                        pl(.away, 4),
                        pl(.away, 5),
                    ],
                    validSquares: [
                        sq(0, 0),
                        sq(1, 0),
                        sq(2, 0),
                        sq(3, 0),
                        sq(4, 0),
                        sq(5, 0),
                        sq(6, 0),
                        sq(7, 0),
                        sq(8, 0),
                        sq(9, 0),
                        sq(10, 0),
                    ]
                )
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
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 0),
                    to: sq(0, 0)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 1),
                    to: sq(1, 0)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 2),
                    to: sq(4, 0)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 3),
                    to: sq(6, 0)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 4),
                    to: sq(9, 0)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 5),
                    to: sq(10, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .arrangePlayers(
                    playerIDs: [
                        pl(.home, 0),
                        pl(.home, 1),
                        pl(.home, 2),
                        pl(.home, 3),
                        pl(.home, 4),
                        pl(.home, 5),
                    ],
                    validSquares: [
                        sq(0, 14),
                        sq(1, 14),
                        sq(2, 14),
                        sq(3, 14),
                        sq(4, 14),
                        sq(5, 14),
                        sq(6, 14),
                        sq(7, 14),
                        sq(8, 14),
                        sq(9, 14),
                        sq(10, 14),
                    ]
                )
            )
        )

        // MARK: - Second coach arrange players

        let newBallID = Int()
        ballIDProvider.nextResults = [newBallID]

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
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 0),
                    to: sq(2, 14)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 1),
                    to: sq(3, 14)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 2),
                    to: sq(4, 14)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 3),
                    to: sq(6, 14)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 4),
                    to: sq(7, 14)
                ),
                .playerMovedOutOfReserves(
                    playerID: pl(.home, 5),
                    to: sq(8, 14)
                ),
                .newBallAppeared(ballID: newBallID, in: sq(5, 7)),
                .turnBegan(coachID: .away, isFinal: false)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 3),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 5),
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
                        playerID: pl(.away, 2),
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
                        playerID: pl(.away, 2),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(4, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 2),
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
                    playerID: pl(.away, 2),
                    ballID: nil,
                    from: sq(4, 0),
                    to: sq(4, 1),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: nil,
                    from: sq(4, 1),
                    to: sq(4, 2),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: nil,
                    from: sq(4, 2),
                    to: sq(4, 3),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: nil,
                    from: sq(4, 3),
                    to: sq(4, 4),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: nil,
                    from: sq(4, 4),
                    to: sq(4, 5),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 2),
                    ballID: nil,
                    from: sq(4, 5),
                    to: sq(4, 6),
                    direction: .south,
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
                                playerID: pl(.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 3),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 5),
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
                        playerID: pl(.away, 3),
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
                        playerID: pl(.away, 3),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(6, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 3),
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
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 0),
                    to: sq(6, 1),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 1),
                    to: sq(6, 2),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 2),
                    to: sq(6, 3),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 3),
                    to: sq(6, 4),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 4),
                    to: sq(6, 5),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 3),
                    ballID: nil,
                    from: sq(6, 5),
                    to: sq(6, 6),
                    direction: .south,
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
                                playerID: pl(.away, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 5),
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
                        playerID: pl(.away, 1),
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
                        playerID: pl(.away, 1),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(1, 0)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 1),
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
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(1, 0),
                    to: sq(1, 1),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(1, 1),
                    to: sq(1, 2),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(1, 2),
                    to: sq(0, 3),
                    direction: .southWest,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 3),
                    to: sq(0, 4),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(0, 4),
                    to: sq(1, 5),
                    direction: .southEast,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 1),
                    ballID: nil,
                    from: sq(1, 5),
                    to: sq(1, 6),
                    direction: .south,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
                .turnBegan(
                    coachID: .home,
                    isFinal: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 2),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 3),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 4),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 5),
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
