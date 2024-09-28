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

        // MARK: - Init

        let coachIDRandomizer = CoachIDRandomizerDouble()
        let deckRandomizer = DeckRandomizerDouble()
        let playerNumberRandomizer = PlayerNumberRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .config(Config()),
            previousPrompt: nil,
            randomizers: Randomizers(
                coachID: coachIDRandomizer,
                deck: deckRandomizer,
                playerNumber: playerNumberRandomizer
            ),
            ballIDProvider: ballIDProvider
        )

        coachIDRandomizer.nextResult = .away

        // MARK: - Begin

        _ = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            )
        )

        // MARK: - Second coach config

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyBoardSpec(boardSpecID: .season2Board1)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyChallengeDeck(challengeDeckID: .shortStandard)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyRookieBonusRecipient(rookieBonusRecipientID: .coinFlipLoser)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyCoinFlipWinnerTeam(teamID: .lizardmen)
            )
        )

        // MARK: - First coach config

        deckRandomizer.nextResult = Array(ChallengeCard.standardShortDeck.prefix(5))

        playerNumberRandomizer.nextResults = [[2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24]]

        let (latestEvents, _) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyCoinFlipLoserTeam(teamID: .orc)
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
                    top: .breakSomeBones,
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .third,
                    objective: .freeUpTheBall
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
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

        // MARK: - Init

        let coachIDRandomizer = CoachIDRandomizerDouble()
        let deckRandomizer = DeckRandomizerDouble()
        let playerNumberRandomizer = PlayerNumberRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .config(Config()),
            previousPrompt: nil,
            randomizers: Randomizers(
                coachID: coachIDRandomizer,
                deck: deckRandomizer,
                playerNumber: playerNumberRandomizer
            ),
            ballIDProvider: ballIDProvider
        )

        coachIDRandomizer.nextResult = .away

        // MARK: - Begin

        _ = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            )
        )

        // MARK: - Second coach config

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyBoardSpec(boardSpecID: .season2Board1)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyChallengeDeck(challengeDeckID: .shortStandard)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyRookieBonusRecipient(rookieBonusRecipientID: .coinFlipWinner)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyCoinFlipWinnerTeam(teamID: .lizardmen)
            )
        )

        // MARK: - First coach config

        deckRandomizer.nextResult = Array(ChallengeCard.standardShortDeck.prefix(5))

        playerNumberRandomizer.nextResults = [[2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24]]

        let (latestEvents, _) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyCoinFlipLoserTeam(teamID: .orc)
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
                    top: .breakSomeBones,
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .third,
                    objective: .freeUpTheBall
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
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

        // MARK: - Init

        let coachIDRandomizer = CoachIDRandomizerDouble()
        let deckRandomizer = DeckRandomizerDouble()
        let playerNumberRandomizer = PlayerNumberRandomizerDouble()

        let ballIDProvider = BallIDProviderDouble()

        var game = Game(
            phase: .config(Config()),
            previousPrompt: nil,
            randomizers: Randomizers(
                coachID: coachIDRandomizer,
                deck: deckRandomizer,
                playerNumber: playerNumberRandomizer
            ),
            ballIDProvider: ballIDProvider
        )

        coachIDRandomizer.nextResult = .away

        // MARK: - Begin

        _ = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .begin
            )
        )

        // MARK: - Second coach config

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyBoardSpec(boardSpecID: .season2Board1)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyChallengeDeck(challengeDeckID: .shortStandard)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyRookieBonusRecipient(rookieBonusRecipientID: .noOne)
            )
        )

        _ = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .specifyCoinFlipWinnerTeam(teamID: .lizardmen)
            )
        )

        // MARK: - First coach config

        deckRandomizer.nextResult = Array(ChallengeCard.standardShortDeck.prefix(5))

        playerNumberRandomizer.nextResults = [[2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24]]

        let (latestEvents, _) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .specifyCoinFlipLoserTeam(teamID: .orc)
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
                    top: .breakSomeBones,
                    count: 5
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .breakSomeBones,
                    count: 4
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: .breakSomeBones
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
                    count: 3
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .third,
                    objective: .freeUpTheBall
                ),
                .updatedDeck(
                    top: .freeUpTheBall,
                    count: 2
                ),
            ]
        )

        #expect(game.table.coinFlipLoserHand == [])
        #expect(game.table.coinFlipWinnerHand == [])
    }

    @Test func usedAfterPassRoll() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
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

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(8, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(2, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(1, 6)]
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 3),
                .changedPassResult(
                    die: .d6,
                    unmodified: 3,
                    modified: 2,
                    modifications: [.longDistance, .targetPlayerMarked]
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionResultEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    result: 2
                )
            )
        )

        // MARK: - Use reroll

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseRawTalentBonusPlayReroll
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
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
                    in: sq(2, 6),
                    ballID: 123
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedAfterPassRoll() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
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

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .pass
                    ),
                    isFree: false,
                    playerSquare: sq(8, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(2, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: [sq(1, 6)]
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(coachID: .away, die: .d6, unmodified: 3),
                .changedPassResult(
                    die: .d6,
                    unmodified: 3,
                    modified: 2,
                    modifications: [.longDistance, .targetPlayerMarked]
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionResultEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    result: 2
                )
            )
        )

        // MARK: - Decline reroll

        directionRandomizer.nextResults = [.north]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionDeclineRawTalentBonusPlayReroll
            )
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
                    in: sq(2, 6),
                    ballID: 123
                ),
                .ballCameLoose(ballID: 123, in: sq(2, 6)),
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func usedAfterHurlTeammateRoll() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

        let ballID = 123

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
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

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: pl(.away, 0),
                    validTeammates: [
                        pl(.away, 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 3), sq(2, 4), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(2, 4), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .long, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(1, 11), sq(2, 10), sq(2, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .short, obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11), sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 11), sq(2, 10), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .short, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 1), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(9, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(8, 10), sq(9, 11), sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(10, 1), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(8, 4), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 3), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 4), sq(8, 3), sq(9, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(8, 4), sq(9, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(8, 10), sq(7, 8), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 11), distance: .long, obstructingSquares: [sq(9, 11), sq(7, 8), sq(8, 10), sq(9, 10), sq(8, 11)]),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d6Randomizer.nextResults = [1]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(coachID: .away, die: .d6, unmodified: 1),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    result: 1
                )
            )
        )

        // MARK: - Use reroll

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionUseRawTalentBonusPlayReroll
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
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
                    in: sq(7, 6)
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
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
                                playerID: pl(.away, 1),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 1),
                                actionID: .pass
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedAfterHurlTeammateRoll() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = 123

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
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

        #expect(
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .hurlTeammate
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: pl(.away, 0),
                    validTeammates: [
                        pl(.away, 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: pl(.away, 1)
                )
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 3), sq(2, 4), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(2, 4), sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .long, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(1, 11), sq(2, 10), sq(2, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(1, 3), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .short, obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11), sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 11), sq(2, 10), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .short, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 1), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(9, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(8, 10), sq(9, 11), sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(10, 1), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(8, 4), sq(9, 3)]),
                        HurlTeammateTarget(targetSquare: sq(10, 3), distance: .long, obstructingSquares: [sq(9, 3), sq(8, 4), sq(8, 3), sq(9, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(8, 4), sq(9, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: [sq(7, 8)]),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(8, 10), sq(7, 8), sq(9, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 11), distance: .long, obstructingSquares: [sq(9, 11), sq(7, 8), sq(8, 10), sq(9, 10), sq(8, 11)]),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        d6Randomizer.nextResults = [1]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(coachID: .away, die: .d6, unmodified: 1),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    result: 1
                )
            )
        )

        // MARK: - Decline reroll

        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionDeclineRawTalentBonusPlayReroll
            )
        )

        #expect(
            latestEvents == [
                .playerFumbledTeammate(
                    playerID: pl(.away, 0),
                    in: sq(3, 6),
                    teammateID: pl(.away, 1),
                    ballID: 123
                ),
                .playerInjured(
                    playerID: pl(.away, 1),
                    in: sq(3, 6),
                    reason: .fumbled
                ),
                .ballCameLoose(ballID: 123, in: sq(3, 6)),
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
                                actionID: .reserves
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func usedAfterBlockRoll() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.smash]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.smash]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.smash],
                    clawsResult: nil,
                    maySelectResultToDecline: false
                )
            )
        )

        // MARK: - Use reroll

        blockDieRandomizer.nextResults = [.shove]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.shove]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .shove
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    reason: .shoved
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionEligibleForFollowUp(
                    playerID: pl(.away, 0),
                    square: sq(2, 6)
                )
            )
        )
    }

    @Test func declinedAfterBlockRoll() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.miss]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.miss]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.miss],
                    clawsResult: nil,
                    maySelectResultToDecline: false
                )
            )
        )

        // MARK: - Decline reroll

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                    result: nil
                )
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .miss
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    in: sq(3, 6)
                ),
                .turnEnded(coachID: .away),
                .playerCanTakeActions(
                    playerID: pl(.away, 0),
                    in: sq(3, 6)
                ),
                .turnBegan(coachID: .home, isFinal: true),
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.home, 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func ineligibleAfterDecliningOffensiveSpecialistSkillReroll() async throws {

        // MARK: - Init

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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch, .miss]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.kerrunch, .miss]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
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
                .declinedOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    in: sq(3, 6)
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(3, 7),
                    to: sq(2, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
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
                                playerID: pl(.away, 0),
                                actionID: .foul
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
                                playerID: pl(.away, 1),
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

    @Test func ineligibleAfterUsingOffensiveSpecialistSkillReroll() async throws {

        // MARK: - Init

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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove, .miss]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.shove, .miss]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
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
                .usedOffensiveSpecialistSkillReroll(
                    playerID: pl(.away, 0),
                    in: sq(3, 6)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash, .miss]
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSelectResult(
                    playerID: pl(.away, 0),
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
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(3, 7),
                    to: sq(2, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 3
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
                                playerID: pl(.away, 0),
                                actionID: .foul
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
                                playerID: pl(.away, 1),
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

    @Test func usedWhenBlockingAsEnforcer() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = 123

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
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
                            id: ballID,
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove, .miss, .shove]
        d6Randomizer.nextResults = [3, 3]
        directionRandomizer.nextResults = [.east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.shove, .miss, .shove]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.shove, .shove, .miss],
                    clawsResult: nil,
                    maySelectResultToDecline: false
                )
            )
        )

        // MARK: - Use reroll

        blockDieRandomizer.nextResults = [.smash, .kerrunch, .smash]
        d6Randomizer.nextResults = [1]
        directionRandomizer.nextResults = [.east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash, .kerrunch, .smash]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(2, 7),
                    to: sq(1, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, in: sq(1, 6)),
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
                    in: sq(2, 6),
                    ballID: 123
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 1
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
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
                                playerID: pl(.away, 0),
                                actionID: .pass
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedWhenBlockingAsEnforcer() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = 123

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .season1Board1,
                        challengeDeckID: .shortStandard,
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
                            id: ballID,
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
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer,
                direction: directionRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.shove, .miss, .shove]
        d6Randomizer.nextResults = [3, 3]
        directionRandomizer.nextResults = [.east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.shove, .miss, .shove]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.shove, .shove, .miss],
                    clawsResult: nil,
                    maySelectResultToDecline: false
                )
            )
        )

        // MARK: - Decline reroll

        d6Randomizer.nextResults = [3]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(result: nil)
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .shove
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerAssistedBlock(
                    assistingPlayerID: pl(.away, 1),
                    from: sq(2, 7),
                    to: sq(1, 6),
                    direction: .northWest,
                    targetPlayerID: pl(.home, 0),
                    blockingPlayerID: pl(.away, 0)
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
                    result: .shove
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(0, 6),
                    reason: .blocked
                ),
                .ballCameLoose(ballID: 123, in: sq(0, 6)),
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
                    result: .miss
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    in: sq(1, 6)
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
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func usedWhenBlockingWithClaws() async throws {

        // MARK: - Init

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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(2, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0)
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch]
        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForClaws(coachID: .away, result: 5),
                .rolledForBlock(coachID: .away, results: [.kerrunch]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.kerrunch],
                    clawsResult: 5,
                    maySelectResultToDecline: false
                )
            )
        )

        // MARK: - Use reroll

        d6Randomizer.nextResults = [6]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
                ),
                .rolledForClaws(
                    coachID: .away,
                    result: 6
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(2, 6),
                    to: sq(1, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(1, 6),
                    reason: .blocked
                ),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func usedWhenBlockingWithMultipleDice() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.miss, .tackle, .shove]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.miss, .tackle, .shove]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.miss, .tackle, .shove],
                    clawsResult: nil,
                    maySelectResultToDecline: true
                )
            )
        )

        // MARK: - Use reroll

        blockDieRandomizer.nextResults = [.miss, .miss, .tackle]
        d6Randomizer.nextResults = [1]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseRawTalentBonusPlayRerollForBlockDieResults
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
                ),
                .rolledForBlock(coachID: .away, results: [.miss, .miss, .tackle]),
                .discardedPersistentBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSelectResult(
                    playerID: pl(.away, 0),
                    results: [.miss, .miss, .tackle]
                )
            )
        )

        // MARK: - Select die

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSelectResult(result: .tackle)
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .tackle
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    in: sq(3, 6)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 1
                ),
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
                    reason: .blocked
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
                                playerID: pl(.away, 1),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedWhenBlockingWithMultipleDice() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.miss, .tackle, .shove]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(coachID: .away, results: [.miss, .tackle, .shove]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.away, 0),
                    results: [.miss, .tackle, .shove],
                    clawsResult: nil,
                    maySelectResultToDecline: true
                )
            )
        )

        // MARK: - Decline reroll

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                    result: .shove
                )
            )
        )

        #expect(
            latestEvents == [
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .shove
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 6),
                    to: sq(2, 6),
                    direction: .west,
                    targetPlayerID: pl(.home, 0)
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
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionEligibleForFollowUp(
                    playerID: pl(.away, 0),
                    square: sq(2, 6)
                )
            )
        )
    }

    @Test func usedAfterArmourRoll() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch]
        d6Randomizer.nextResults = [2]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .away,
                    results: [.kerrunch]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch
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
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 2
                ),
                .changedArmourResult(
                    die: .d6,
                    unmodified: 2,
                    modified: 1,
                    modifications: [.kerrunch]
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.home, 0),
                    result: 1
                )
            )
        )

        // MARK: - Use reroll

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionUseRawTalentBonusPlayRerollForArmourResult
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    ),
                    hand: []
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
                .discardedPersistentBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .rawTalent
                    )
                ),
                .updatedDiscards(
                    top: .rawTalent,
                    count: 1
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
                                playerID: pl(.away, 0),
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

    @Test func declinedAfterArmourRoll() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch]
        d6Randomizer.nextResults = [2]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .away,
                    results: [.kerrunch]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch
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
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 2
                ),
                .changedArmourResult(
                    die: .d6,
                    unmodified: 2,
                    modified: 1,
                    modifications: [.kerrunch]
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
                    playerID: pl(.home, 0),
                    result: 1
                )
            )
        )

        // MARK: - Decline reroll

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionDeclineRawTalentBonusPlayRerollForArmourResult
            )
        )

        #expect(
            latestEvents == [
                .playerInjured(
                    playerID: pl(.home, 0),
                    in: sq(2, 6),
                    reason: .blocked
                )
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
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func ineligibleForArmourIfNotInjured() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = 123

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
                            id: ballID,
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
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .block
                    ),
                    isFree: false,
                    playerSquare: sq(3, 6)
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        pl(.home, 0),
                    ]
                )
            )
        )

        // MARK: - Specify block

        blockDieRandomizer.nextResults = [.kerrunch]
        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: pl(.home, 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(
                    coachID: .away,
                    results: [.kerrunch]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .kerrunch
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
                    reason: .blocked
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
                                playerID: pl(.away, 0),
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
