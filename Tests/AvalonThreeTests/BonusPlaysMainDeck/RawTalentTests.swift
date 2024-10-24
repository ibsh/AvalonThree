//
//  RawTalentTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct RawTalentTests {

    @Test func coinFlipWinnerCanGiveACopyToCoinFlipLoser() async throws {

        // Init

        var game = Game()

        // Begin

        _ = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            ),
            randomizers: Randomizers(coachID: coachID(.away))
        )

        // Second coach config

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectBoardSpec(boardSpecID: .season2Board1)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .configureChallengeDeck(
                    challengeDeckConfig: ChallengeDeckConfig(
                        useEndgameCards: false,
                        randomizeBonusPlays: false
                    )
                )
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectRookieBonusRecipient(rookieBonusRecipientID: .coinFlipLoser)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectTeam(teamID: .lizardmen)
            )
        )

        // First coach config

        let (latestEvents, _) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectTeam(teamID: .orc)
            ),
            randomizers: Randomizers(
                deck: deck(Array(ChallengeCard.standardShortDeck.prefix(5))),
                playerNumber: playerNumber(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24)
            )
        )

        #expect(
            latestEvents == [
                .specifiedTeam(
                    coachID: .home,
                    teamID: TeamID.orc
                ),
                .startingHandWasSetUp(
                    coachID: .away,
                    hand: []
                ),
                .startingHandWasSetUp(
                    coachID: .home,
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .rookieBonus,
                                bonusPlay: .rawTalent
                            )
                        )
                    ]
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 0),
                    number: 2
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 1),
                    number: 4
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 2),
                    number: 6
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 3),
                    number: 8
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 4),
                    number: 10
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 5),
                    number: 12
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 0),
                    number: 14
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 1),
                    number: 16
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 2),
                    number: 18
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 3),
                    number: 20
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 4),
                    number: 22
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 5),
                    number: 24
                ),
                .startingPlayersWereSetUp(
                    coachID: .away,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.away, 0),
                            specID: PlayerSpecID
                                .lizardmen_skinkRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 6,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 1),
                            specID: PlayerSpecID
                                .lizardmen_skinkRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 6,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 2),
                            specID: PlayerSpecID
                                .lizardmen_chameleonSkinkCatcher,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 3,
                                armour: 5,
                                skills: [
                                    PlayerSpec.Skill
                                        .catchersInstincts
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 3),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 4),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 5),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                    ]
                ),
                .startingPlayersWereSetUp(
                    coachID: .home,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.home, 0),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 1),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 2),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 3),
                            specID: PlayerSpecID
                                .orc_passer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
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
                            id: pl(.home, 4),
                            specID: PlayerSpecID
                                .orc_blitzer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: [
                                    PlayerSpec.Skill
                                        .offensiveSpecialist
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 5),
                            specID: PlayerSpecID
                                .orc_bigUnBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                    ]
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .breakSomeBones, value: 3),
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 0,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .breakSomeBones, value: 3),
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .freeUpTheBall, value: 2),
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 2,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        third: WrappedObjective(challenge: .freeUpTheBall, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .freeUpTheBall, value: 2),
                    count: 2
                ),
            ]
        )

        #expect(game.table.coinFlipLoserHand == [
            ChallengeCard(challenge: .rookieBonus, bonusPlay: .rawTalent),
        ])
        #expect(game.table.coinFlipWinnerHand == [])
    }

    @Test func coinFlipWinnerCanGiveACopyToCoinFlipWinner() async throws {

        // Init

        var game = Game()

        // Begin

        _ = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            ),
            randomizers: Randomizers(coachID: coachID(.away))
        )

        // Second coach config

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectBoardSpec(boardSpecID: .season2Board1)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .configureChallengeDeck(
                    challengeDeckConfig: ChallengeDeckConfig(
                        useEndgameCards: false,
                        randomizeBonusPlays: false
                    )
                )
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectRookieBonusRecipient(rookieBonusRecipientID: .coinFlipWinner)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectTeam(teamID: .lizardmen)
            )
        )

        // First coach config

        let (latestEvents, _) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectTeam(teamID: .orc)
            ),
            randomizers: Randomizers(
                deck: deck(Array(ChallengeCard.standardShortDeck.prefix(5))),
                playerNumber: playerNumber(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24)
            )
        )

        #expect(
            latestEvents == [
                .specifiedTeam(
                    coachID: .home,
                    teamID: TeamID.orc
                ),
                .startingHandWasSetUp(
                    coachID: .away,
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .rookieBonus,
                                bonusPlay: .rawTalent
                            )
                        )
                    ]
                ),
                .startingHandWasSetUp(
                    coachID: .home,
                    hand: []
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 0),
                    number: 2
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 1),
                    number: 4
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 2),
                    number: 6
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 3),
                    number: 8
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 4),
                    number: 10
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 5),
                    number: 12
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 0),
                    number: 14
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 1),
                    number: 16
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 2),
                    number: 18
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 3),
                    number: 20
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 4),
                    number: 22
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 5),
                    number: 24
                ),
                .startingPlayersWereSetUp(
                    coachID: .away,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.away, 0),
                            specID: PlayerSpecID
                                .lizardmen_skinkRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 6,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 1),
                            specID: PlayerSpecID
                                .lizardmen_skinkRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 6,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 2),
                            specID: PlayerSpecID
                                .lizardmen_chameleonSkinkCatcher,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 3,
                                armour: 5,
                                skills: [
                                    PlayerSpec.Skill
                                        .catchersInstincts
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 3),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 4),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 5),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                    ]
                ),
                .startingPlayersWereSetUp(
                    coachID: .home,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.home, 0),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 1),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 2),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 3),
                            specID: PlayerSpecID
                                .orc_passer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
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
                            id: pl(.home, 4),
                            specID: PlayerSpecID
                                .orc_blitzer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: [
                                    PlayerSpec.Skill
                                        .offensiveSpecialist
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 5),
                            specID: PlayerSpecID
                                .orc_bigUnBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                    ]
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .breakSomeBones, value: 3),
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 0,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .breakSomeBones, value: 3),
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .freeUpTheBall, value: 2),
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 2,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        third: WrappedObjective(challenge: .freeUpTheBall, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .freeUpTheBall, value: 2),
                    count: 2
                ),
            ]
        )

        #expect(game.table.coinFlipLoserHand == [])
        #expect(game.table.coinFlipWinnerHand == [
            ChallengeCard(challenge: .rookieBonus, bonusPlay: .rawTalent),
        ])
    }

    @Test func coinFlipWinnerCanGiveACopyToNeitherCoach() async throws {

        // Init

        var game = Game()

        // Begin

        _ = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            ),
            randomizers: Randomizers(coachID: coachID(.away))
        )

        // Second coach config

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectBoardSpec(boardSpecID: .season2Board1)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .configureChallengeDeck(
                    challengeDeckConfig: ChallengeDeckConfig(
                        useEndgameCards: false,
                        randomizeBonusPlays: false
                    )
                )
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectRookieBonusRecipient(rookieBonusRecipientID: .noOne)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectTeam(teamID: .lizardmen)
            )
        )

        // First coach config

        let (latestEvents, _) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectTeam(teamID: .orc)
            ),
            randomizers: Randomizers(
                deck: deck(Array(ChallengeCard.standardShortDeck.prefix(5))),
                playerNumber: playerNumber(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24)
            )
        )

        #expect(
            latestEvents == [
                .specifiedTeam(
                    coachID: .home,
                    teamID: TeamID.orc
                ),
                .startingHandWasSetUp(
                    coachID: .away,
                    hand: []
                ),
                .startingHandWasSetUp(
                    coachID: .home,
                    hand: []
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 0),
                    number: 2
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 1),
                    number: 4
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 2),
                    number: 6
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 3),
                    number: 8
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 4),
                    number: 10
                ),
                .playerReceivedNumber(
                    playerID: pl(.home, 5),
                    number: 12
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 0),
                    number: 14
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 1),
                    number: 16
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 2),
                    number: 18
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 3),
                    number: 20
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 4),
                    number: 22
                ),
                .playerReceivedNumber(
                    playerID: pl(.away, 5),
                    number: 24
                ),
                .startingPlayersWereSetUp(
                    coachID: .away,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.away, 0),
                            specID: PlayerSpecID
                                .lizardmen_skinkRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 6,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 1),
                            specID: PlayerSpecID
                                .lizardmen_skinkRunner,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(8),
                                block: 1,
                                pass: 4,
                                armour: 6,
                                skills: [
                                    PlayerSpec.Skill
                                        .safeHands
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 2),
                            specID: PlayerSpecID
                                .lizardmen_chameleonSkinkCatcher,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(7),
                                block: 1,
                                pass: 3,
                                armour: 5,
                                skills: [
                                    PlayerSpec.Skill
                                        .catchersInstincts
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 3),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 4),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.away, 5),
                            specID: PlayerSpecID
                                .lizardmen_saurusBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                    ]
                ),
                .startingPlayersWereSetUp(
                    coachID: .home,
                    playerSetups: [
                        PlayerSetup(
                            id: pl(.home, 0),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 1),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 2),
                            specID: PlayerSpecID
                                .orc_lineman,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: []
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 3),
                            specID: PlayerSpecID
                                .orc_passer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
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
                            id: pl(.home, 4),
                            specID: PlayerSpecID
                                .orc_blitzer,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(6),
                                block: 1,
                                pass: 4,
                                armour: 2,
                                skills: [
                                    PlayerSpec.Skill
                                        .offensiveSpecialist
                                ]
                            )
                        ),
                        PlayerSetup(
                            id: pl(.home, 5),
                            specID: PlayerSpecID
                                .orc_bigUnBlocker,
                            spec: PlayerSpec(
                                move: PlayerSpec.Move
                                    .fixed(5),
                                block: 2,
                                pass: 6,
                                armour: 2,
                                skills: []
                            )
                        ),
                    ]
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .breakSomeBones, value: 3),
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 0,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .breakSomeBones, value: 3),
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        third: nil
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .freeUpTheBall, value: 2),
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 2,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        third: WrappedObjective(challenge: .freeUpTheBall, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .freeUpTheBall, value: 2),
                    count: 2
                ),
            ]
        )

        #expect(game.table.coinFlipLoserHand == [])
        #expect(game.table.coinFlipWinnerHand == [])
    }

    @Test func usedAfterPassRoll() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_passer,
                            state: .standing(square: sq(8, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 6)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare pass

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(3))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseRawTalentBonusPlayReroll
            ),
            randomizers: Randomizers(d6: d6(4))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 4
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [
                        .longDistance,
                        .targetPlayerMarked,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(8, 6),
                    to: sq(2, 6),
                    angle: 270,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterPassRoll() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_passer,
                            state: .standing(square: sq(8, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 6)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare pass

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        // Select pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(3))

        )

        // Decline reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionDeclineRawTalentBonusPlayReroll
            ),
            randomizers: Randomizers(direction: direction(.north))
        )

        #expect(
            latestEvents == [
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(8, 6),
                    to: sq(2, 6),
                    angle: 270,
                    ballID: 123
                ),
                .playerFailedCatch(
                    playerID: pl(.away, 1),
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(2, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .north
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(2, 6),
                    to: sq(2, 5),
                    direction: .north
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterHurlTeammateRoll() async throws {

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
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 1))
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

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(7, 6))
            ),
            randomizers: Randomizers(d6: d6(1))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionUseRawTalentBonusPlayReroll
            ),
            randomizers: Randomizers(d6: d6(5))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(3, 6),
                    to: sq(7, 6),
                    angle: 90
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    playerSquare: sq(7, 6)
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterHurlTeammateRoll() async throws {

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
                        coinFlipLoserTeamID: .halfling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .human_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 1))
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

        // Declare hurl teammate

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        // Select target square

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSelectTarget(targetSquare: sq(7, 6))
            ),
            randomizers: Randomizers(d6: d6(1))
        )

        // Decline reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionDeclineRawTalentBonusPlayReroll
            ),
            randomizers: Randomizers(direction: direction(.west))
        )

        #expect(
            latestEvents == [
                .playerFumbledTeammate(
                    playerID: pl(.away, 0),
                    playerSquare: sq(3, 6),
                    teammateID: pl(.away, 1),
                    ballID: 123
                ),
                .playerInjured(
                    playerID: pl(.away, 1),
                    playerSquare: sq(3, 6),
                    reason: .fumbled
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(3, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .west
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedAfterBlockRoll() async throws {

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
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            randomizers: Randomizers(blockDie: block(.smash))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            ),
            randomizers: Randomizers(blockDie: block(.shove))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.shove])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.shove])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    reason: .shoved
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionEligibleForFollowUp(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(3, 6)
                    ),
                    destination: sq(2, 6)
                )
            )
        )
    }

    @Test func declinedAfterBlockRoll() async throws {

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
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            randomizers: Randomizers(blockDie: block(.miss))
        )

        // Can't decline reroll with a result argument

        #expect(throws: GameError("May not select result")) {
            try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                        dieIndex: 0
                    )
                )
            )
        }

        // Decline reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                    dieIndex: nil
                )
            )
        )

        #expect(
            latestEvents == [
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

    @Test func ineligibleAfterDecliningOffensiveSpecialistSkillReroll() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 7)),
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
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
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
            ),
            randomizers: Randomizers(blockDie: block(.miss, .kerrunch))
        )

        // Choose block result rather than reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineOffensiveSpecialistSkillReroll(
                    dieIndex: 1
                )
            ),
            randomizers: Randomizers(d6: d6(5))
        )

        #expect(
            latestEvents == [
                .declinedOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    playerSquare: sq(3, 6)
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 1,
                    from: BlockResults(dice: [.miss, .kerrunch])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: [
                        AssistingPlayer(
                            id: pl(.away, 1),
                            square: sq(3, 7),
                            direction: .northWest
                        ),
                    ]
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(2, 6),
                    reason: .blocked
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
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func ineligibleAfterUsingOffensiveSpecialistSkillReroll() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_blitzer,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(3, 7)),
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
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
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
            ),
            randomizers: Randomizers(blockDie: block(.shove, .miss))
        )

        // Choose to reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseOffensiveSpecialistSkillReroll
            ),
            randomizers: Randomizers(blockDie: block(.smash, .miss))
        )

        // Choose block result

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(
                    dieIndex: 0
                )
            ),
            randomizers: Randomizers(d6: d6(3))
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.smash, .miss])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: [
                        AssistingPlayer(
                            id: pl(.away, 1),
                            square: sq(3, 7),
                            direction: .northWest
                        ),
                    ]
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(2, 6),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 3
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedWhenBlockingAsEnforcer() async throws {

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
                        coinFlipLoserTeamID: .khorne
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .khorne_bloodseeker,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .khorne_marauder,
                            state: .standing(square: sq(2, 7)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
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
            randomizers: Randomizers(blockDie: block(.shove, .miss, .shove), d6: d6(3, 3), direction: direction(.east))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            ),
            randomizers: Randomizers(blockDie: block(.smash, .kerrunch, .smash), d6: d6(1), direction: direction(.east))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.smash, .smash, .kerrunch])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.smash, .smash, .kerrunch])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: [
                        AssistingPlayer(
                            id: pl(.away, 1),
                            square: sq(2, 7),
                            direction: .northWest
                        ),
                    ]
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(1, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(1, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .east
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(1, 6),
                    to: sq(2, 6),
                    direction: .east
                ),
                .playerCaughtBouncingBall(
                    playerID: pl(.away, 0),
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 1
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    playerSquare: sq(1, 6),
                    reason: .blocked
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 1,
                    from: BlockResults(dice: [.smash, .smash, .kerrunch])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 2,
                    from: BlockResults(dice: [.smash, .smash, .kerrunch])
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent, count: 1
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedWhenBlockingAsEnforcer() async throws {

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
                        coinFlipLoserTeamID: .khorne
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .khorne_bloodseeker,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .khorne_marauder,
                            state: .standing(square: sq(2, 7)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
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
            randomizers: Randomizers(
                blockDie: block(.shove, .miss, .shove),
                d6: d6(3, 3),
                direction: direction(.east)
            )
        )

        // Can't decline reroll with a result argument

        #expect(throws: GameError("May not select result")) {
            try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                        dieIndex: 0
                    )
                )
            )
        }

        // Decline reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                    dieIndex: nil
                )
            ),
            randomizers: Randomizers(d6: d6(3), direction: direction(.south))
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.shove, .shove, .miss])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: [
                        AssistingPlayer(
                            id: pl(.away, 1),
                            square: sq(2, 7),
                            direction: .northWest
                        ),
                    ]
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: 123,
                    from: sq(1, 6),
                    to: sq(0, 6),
                    direction: .west,
                    reason: .shoved
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    reason: .followUp
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 1,
                    from: BlockResults(dice: [.shove, .shove, .miss])
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(0, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, ballSquare: sq(0, 6)),
                .rolledForDirection(
                    coachID: .away,
                    direction: .south
                ),
                .ballBounced(
                    ballID: 123,
                    from: sq(0, 6),
                    to: sq(0, 7),
                    direction: .south
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 3
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 2,
                    from: BlockResults(dice: [.shove, .shove, .miss])
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    playerSquare: sq(1, 6)
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedWhenBlockingWithClaws() async throws {

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
                        coinFlipLoserTeamID: .necromantic
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .necromantic_werewolf,
                            state: .standing(square: sq(2, 6)),
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
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
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
            ),
            randomizers: Randomizers(blockDie: block(.kerrunch), d6: d6(5))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            ),
            randomizers: Randomizers(blockDie: block(.miss), d6: d6(6))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: BlockResults(dice: [.miss], claws: 6)
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(1, 6),
                    reason: .blocked
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    playerSquare: sq(1, 6),
                    reason: .blocked
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func usedWhenBlockingWithMultipleDice() async throws {

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
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_pumpWagon,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(2, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .loose(square: sq(6, 6))
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
            randomizers: Randomizers(blockDie: block(.miss, .tackle, .shove))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            ),
            randomizers: Randomizers(blockDie: block(.miss, .miss, .tackle))
        )

        // Select die

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(
                    dieIndex: 2
                )
            ),
            randomizers: Randomizers(d6: d6(1))
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 2,
                    from: BlockResults(dice: [.miss, .miss, .tackle])
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
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(2, 6),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 1
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    playerSquare: sq(2, 6),
                    reason: .blocked
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedWhenBlockingWithMultipleDice() async throws {

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
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .snotling_pumpWagon,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            randomizers: Randomizers(blockDie: block(.miss, .tackle, .shove))
        )

        // Can't decline reroll without a result argument

        #expect(throws: GameError("Must select result")) {
            try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                        dieIndex: nil
                    )
                )
            )
        }

        // Decline reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                    dieIndex: 2
                )
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 2,
                    from: BlockResults(dice: [.miss, .tackle, .shove])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    reason: .shoved
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .blockActionEligibleForFollowUp(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(3, 6)
                    ),
                    destination: sq(2, 6)
                )
            )
        )
    }

    @Test func usedAfterArmourRoll() async throws {

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
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            randomizers: Randomizers(blockDie: block(.kerrunch), d6: d6(2))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionUseRawTalentBonusPlayRerollForArmourResult
            ),
            randomizers: Randomizers(d6: d6(4))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 4
                ),
                .changedArmourResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [.kerrunch]
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func declinedAfterArmourRoll() async throws {

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
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            randomizers: Randomizers(blockDie: block(.kerrunch), d6: d6(2))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .rolledForArmour,
                .changedArmourResult,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .blockActionArmourResultEligibleForRawTalentBonusPlayReroll)

        // Decline reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionDeclineRawTalentBonusPlayRerollForArmourResult
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerInjured,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func ineligibleForArmourIfNotInjured() async throws {

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
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
            randomizers: Randomizers(blockDie: block(.kerrunch), d6: d6(4))
        )

        #expect(
            latestEvents.map { $0.case } == [
                .declaredAction,
                .rolledForBlock,
                .selectedBlockDieResult,
                .playerBlocked,
                .playerFellDown,
                .rolledForArmour,
                .changedArmourResult,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func cantUseTwiceInOneTurn() async throws {

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
                        coinFlipLoserTeamID: .orc
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .orc_passer,
                            state: .standing(square: sq(8, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .orc_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent),
                        ChallengeCard(challenge: .breakTheirLines, bonusPlay: .rawTalent),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare first pass

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        // Select first pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 1))
            ),
            randomizers: Randomizers(d6: d6(3))
        )

        // Use reroll

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseRawTalentBonusPlayReroll
            ),
            randomizers: Randomizers(d6: d6(4))
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .breakTheirLines,
                                bonusPlay: .rawTalent
                            )
                        ),
                    ],
                    active: [
                        ChallengeCard(
                            challenge: .breakSomeBones,
                            bonusPlay: .rawTalent
                        ),
                    ]
                ),
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 4
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 4,
                    modified: 3,
                    modifications: [
                        .longDistance
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(8, 6),
                    to: sq(2, 6),
                    angle: 270,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    playerSquare: sq(2, 6),
                    ballID: 123
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .breakTheirLines,
                                bonusPlay: .rawTalent
                            )
                        ),
                    ],
                    active: []
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)

        // Declare second pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 1),
                        actionID: .pass
                    ),
                    consumesBonusPlays: []
                )
            )
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .passActionSelectTarget)

        // Select second pass

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSelectTarget(target: pl(.away, 0))
            ),
            randomizers: Randomizers(d6: d6(1))
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
