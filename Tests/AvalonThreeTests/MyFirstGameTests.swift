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

        // Init

        var game = Game()

        // Begin

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            ),
            randomizers: Randomizers(coachID: coachID(.home))
        )

        #expect(
            latestEvents == [
                .flippedCoin(coachID: .home)
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectBoardSpec(
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

        // Second coach config

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectBoardSpec(boardSpecID: .season1Board1)
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .configureChallengeDeck
            )
        )

        // Second coach config

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .configureChallengeDeck(
                    challengeDeckConfig: ChallengeDeckConfig(
                        useEndgameCards: false,
                        randomizeBonusPlays: false
                    )
                )
            )
        )

        #expect(
            latestEvents == [
                .configuredChallengeDeck(
                    coachID: .home,
                    challengeDeckConfig: ChallengeDeckConfig(
                        useEndgameCards: false,
                        randomizeBonusPlays: false
                    )
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectRookieBonusRecipient(
                    rookieBonusRecipientIDs: [
                        .noOne,
                        .coinFlipLoser,
                        .coinFlipWinner,
                    ]
                )
            )
        )

        // Second coach config

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectRookieBonusRecipient(rookieBonusRecipientID: .noOne)
            )
        )

        #expect(
            latestEvents == [
                .specifiedRookieBonusRecipient(coachID: .home, recipientCoachID: nil)
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectTeam(
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

        // Second coach config

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectTeam(teamID: .skaven)
            )
        )

        #expect(
            latestEvents == [
                .specifiedTeam(coachID: .home, teamID: .skaven)
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .selectTeam(
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

        // First coach config

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectTeam(teamID: .human)
            ),
            randomizers: Randomizers(
                deck: deck([
                    ChallengeCard(challenge: .gangUp, bonusPlay: .toughEnough),
                    ChallengeCard(challenge: .showNoFear, bonusPlay: .jumpUp),
                    ChallengeCard(challenge: .moveTheBall, bonusPlay: .dodge),
                    ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration),
                    ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                    ChallengeCard(challenge: .getTogether, bonusPlay: .reserves),
                    ChallengeCard(challenge: .getMoving, bonusPlay: .interference),
                    ChallengeCard(challenge: .tieThemUp, bonusPlay: .defensivePlay),
                    ChallengeCard(challenge: .gangUp, bonusPlay: .inspiration),
                    ChallengeCard(challenge: .tieThemUp, bonusPlay: .rawTalent),
                    ChallengeCard(challenge: .moveTheBall, bonusPlay: .rawTalent),
                    ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .intervention),
                    ChallengeCard(challenge: .takeThemDown, bonusPlay: .divingTackle),
                    ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .blitz),
                    ChallengeCard(challenge: .breakSomeBones, bonusPlay: .stepAside),
                    ChallengeCard(challenge: .spreadOut, bonusPlay: .reserves),
                    ChallengeCard(challenge: .getTheBall, bonusPlay: .distraction),
                    ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .multiBall),
                    ChallengeCard(challenge: .showUsACompletion, bonusPlay: .inspiration),
                    ChallengeCard(challenge: .getMoving, bonusPlay: .sprint),
                    ChallengeCard(challenge: .showUsACompletion, bonusPlay: .passingPlay),
                    ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .rawTalent),
                    ChallengeCard(challenge: .getTheBall, bonusPlay: .shadow),
                    ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .accuratePass),
                ]),
                playerNumber: playerNumber(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
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
                    top: WrappedObjective(challenge: .gangUp, value: 2),
                    count: 24
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveIndex: 0,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .gangUp, value: 2),
                        second: nil,
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .showNoFear, value: 2),
                    count: 23
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveIndex: 1,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .gangUp, value: 2),
                        second: WrappedObjective(challenge: .showNoFear, value: 2),
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .moveTheBall, value: 1),
                    count: 22
                ),
                .dealtNewObjective(
                    coachID: .away,
                    objectiveIndex: 2,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .gangUp, value: 2),
                        second: WrappedObjective(challenge: .showNoFear, value: 2),
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .takeThemDown, value: 2),
                    count: 21
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .arrangePlayers(
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

        // First coach arrange players

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .arrangePlayers(
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

        // Second coach arrange players

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            ),
            randomizers: Randomizers(
                ballID: ballID(123)
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
                .newBallAppeared(ballID: 123, ballSquare: sq(5, 7)),
                .turnBegan(coachID: .away, isFinal: false)
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(0, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(1, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 2),
                            square: sq(4, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 3),
                            square: sq(6, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 4),
                            square: sq(9, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 5),
                            square: sq(10, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        // First coach declare turn 1 action 1

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 2),
                        square: sq(4, 0)
                    ),
                    maxDistance: 6,
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

        // First coach select turn 1 action 1

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(0, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(1, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 3),
                            square: sq(6, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 4),
                            square: sq(9, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 5),
                            square: sq(10, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // First coach declare turn 1 action 2

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 3),
                        square: sq(6, 0)
                    ),
                    maxDistance: 6,
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

        // First coach select turn 1 action 2

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(0, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 1),
                            square: sq(1, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 4),
                            square: sq(9, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 5),
                            square: sq(10, 0),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // First coach declare turn 1 action 3

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 1),
                        square: sq(1, 0)
                    ),
                    maxDistance: 6,
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

        // First coach select turn 1 action 3

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 0),
                            square: sq(2, 14),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 1),
                            square: sq(3, 14),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 2),
                            square: sq(4, 14),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 3),
                            square: sq(6, 14),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 4),
                            square: sq(7, 14),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                        PromptValidDeclaringPlayer(
                            playerID: pl(.home, 5),
                            square: sq(8, 14),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }
}
