//
//  MoveTheBallTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/30/24.
//

import Testing
@testable import AvalonThree

struct MoveTheBallTests {

    @Test func notAvailableWhenBallMovesLessThanFourSquares() async throws {

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
                            state: .standing(square: sq(6, 2)),
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
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
                    sq(6, 3),
                    sq(6, 4),
                    sq(6, 5),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .turnEnded,
                .discardedObjective,
                .updatedDiscards,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func availableWhenBallMovesFourSquares() async throws {

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
                            state: .standing(square: sq(6, 2)),
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
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
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
            latestEvents.map { $0.case } == [
                .declaredAction,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .runActionSelectSquares)

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(squares: [
                    sq(6, 3),
                    sq(6, 4),
                    sq(6, 5),
                    sq(6, 6),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .away)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .claimedObjective,
                .scoreUpdated,
                .turnEnded,
                .turnBegan,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }

    @Test func availableAlongsideScoringTouchdown() async throws {

        // Init

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .away,
                        boardSpecID: BoardSpecID.season3Board1,
                        challengeDeckConfig: ChallengeDeckConfig(
                            useEndgameCards: false,
                            randomizeBonusPlays: false
                        ),
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .skaven,
                        coinFlipLoserTeamID: .woodElf
                    ),
                    players: [
                        Player(id: pl(.home, 0), spec: .woodElf_lineman, state: .standing(square: sq(3, 0)), canTakeActions: true),
                        Player(id: pl(.home, 1), spec: .woodElf_lineman, state: .standing(square: sq(5, 10)), canTakeActions: true),
                        Player(id: pl(.home, 2), spec: .woodElf_lineman, state: .standing(square: sq(1, 9)), canTakeActions: true),
                        Player(id: pl(.home, 3), spec: .woodElf_passer, state: .standing(square: sq(1, 2)), canTakeActions: true),
                        Player(id: pl(.home, 4), spec: .woodElf_catcher, state: .prone(square: sq(6, 6)), canTakeActions: true),
                        Player(id: pl(.home, 5), spec: .woodElf_wardancer, state: .standing(square: sq(4, 6)), canTakeActions: true),
                        Player(id: pl(.away, 0), spec: .skaven_lineman, state: .standing(square: sq(1, 7)), canTakeActions: true),
                        Player(id: pl(.away, 1), spec: .skaven_lineman, state: .standing(square: sq(6, 5)), canTakeActions: true),
                        Player(id: pl(.away, 2), spec: .skaven_lineman, state: .standing(square: sq(1, 8)), canTakeActions: true),
                        Player(id: pl(.away, 3), spec: .skaven_passer, state: .inReserves, canTakeActions: true),
                        Player(id: pl(.away, 4), spec: .skaven_gutterRunner, state: .inReserves, canTakeActions: true),
                        Player(id: pl(.away, 5), spec: .skaven_blitzer, state: .standing(square: sq(6, 0)), canTakeActions: true),
                    ],
                    playerNumbers: [
                        pl(.home, 3): 35,
                        pl(.away, 1): 75,
                        pl(.away, 2): 5,
                        pl(.home, 0): 96,
                        pl(.home, 5): 82,
                        pl(.away, 3): 79,
                        pl(.home, 2): 88,
                        pl(.home, 4): 52,
                        pl(.away, 0): 20,
                        pl(.away, 5): 90,
                        pl(.away, 4): 23,
                        pl(.home, 1): 76
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 2,
                    coinFlipWinnerScore: 10,
                    balls: [
                        Ball(id: 84, state: .loose(square: sq(4, 7)))
                    ],
                    deck: [
                        ChallengeCard(challenge: Challenge.breakSomeBones, bonusPlay: BonusPlay.stepAside),
                        ChallengeCard(challenge: Challenge.freeUpTheBall, bonusPlay: BonusPlay.intervention),
                        ChallengeCard(challenge: Challenge.takeThemDown, bonusPlay: BonusPlay.inspiration),
                        ChallengeCard(challenge: Challenge.getTheBall, bonusPlay: BonusPlay.distraction),
                        ChallengeCard(challenge: Challenge.breakSomeBones, bonusPlay: BonusPlay.blockingPlay),
                        ChallengeCard(challenge: Challenge.spreadOut, bonusPlay: BonusPlay.reserves),
                        ChallengeCard(challenge: Challenge.showUsACompletion, bonusPlay: BonusPlay.inspiration),
                        ChallengeCard(challenge: Challenge.showNoFear, bonusPlay: BonusPlay.jumpUp),
                        ChallengeCard(challenge: Challenge.gangUp, bonusPlay: BonusPlay.toughEnough),
                        ChallengeCard(challenge: Challenge.tieThemUp, bonusPlay: BonusPlay.rawTalent)
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: Challenge.moveTheBall, bonusPlay: BonusPlay.dodge),
                        second: ChallengeCard(challenge: Challenge.moveTheBall, bonusPlay: BonusPlay.rawTalent),
                        third: ChallengeCard(challenge: Challenge.getTheBall, bonusPlay: BonusPlay.shadow)
                    ),
                    discards: [
                        ChallengeCard(challenge: Challenge.showboatForTheCrowd, bonusPlay: BonusPlay.rawTalent),
                        ChallengeCard(challenge: Challenge.gangUp, bonusPlay: BonusPlay.inspiration),
                        ChallengeCard(challenge: Challenge.showboatForTheCrowd, bonusPlay: BonusPlay.multiBall),
                        ChallengeCard(challenge: Challenge.makeARiskyPass, bonusPlay: BonusPlay.accuratePass),
                        ChallengeCard(challenge: Challenge.getMoving, bonusPlay: BonusPlay.interference),
                        ChallengeCard(challenge: Challenge.takeThemDown, bonusPlay: BonusPlay.divingTackle),
                        ChallengeCard(challenge: Challenge.getMoving, bonusPlay: BonusPlay.sprint),
                        ChallengeCard(challenge: Challenge.freeUpTheBall, bonusPlay: BonusPlay.blitz),
                        ChallengeCard(challenge: Challenge.getTogether, bonusPlay: BonusPlay.reserves),
                        ChallengeCard(challenge: Challenge.tieThemUp, bonusPlay: BonusPlay.defensivePlay),
                        ChallengeCard(challenge: Challenge.showUsACompletion, bonusPlay: BonusPlay.passingPlay)
                    ]
                ),
                [
                    .prepareForTurn(coachID: .home, isSpecial: nil, mustDiscardObjective: true),
                    .choosingObjectiveToDiscard(objectiveIndices: [2, 0, 1]),
                    .discardedObjective(objectiveIndex: 1),
                    .actionDeclaration(
                        declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: ActionID.standUp),
                        snapshot: ActionSnapshot(
                            balls: [
                                Ball(id: 84, state: .loose(square: sq(4, 7)))
                            ],
                            players: [
                                Player(id: pl(.home, 0), spec: .woodElf_lineman, state: .standing(square: sq(3, 0)), canTakeActions: true),
                                Player(id: pl(.home, 1), spec: .woodElf_lineman, state: .standing(square: sq(5, 10)), canTakeActions: true),
                                Player(id: pl(.home, 2), spec: .woodElf_lineman, state: .standing(square: sq(1, 9)), canTakeActions: true),
                                Player(id: pl(.home, 3), spec: .woodElf_passer, state: .standing(square: sq(1, 2)), canTakeActions: true),
                                Player(id: pl(.home, 4), spec: .woodElf_catcher, state: .prone(square: sq(6, 6)), canTakeActions: true),
                                Player(id: pl(.home, 5), spec: .woodElf_wardancer, state: .standing(square: sq(4, 6)), canTakeActions: true),
                                Player(id: pl(.away, 0), spec: .skaven_lineman, state: .standing(square: sq(1, 7)), canTakeActions: true),
                                Player(id: pl(.away, 1), spec: .skaven_lineman, state: .standing(square: sq(6, 5)), canTakeActions: true),
                                Player(id: pl(.away, 2), spec: .skaven_lineman, state: .standing(square: sq(1, 8)), canTakeActions: true),
                                Player(id: pl(.away, 3), spec: .skaven_passer, state: .inReserves, canTakeActions: true),
                                Player(id: pl(.away, 4), spec: .skaven_gutterRunner, state: .inReserves, canTakeActions: true),
                                Player(id: pl(.away, 5), spec: .skaven_blitzer, state: .standing(square: sq(6, 0)), canTakeActions: true),
                            ]
                        )
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(playerID: pl(.home, 5), actionID: ActionID.run),
                        snapshot: ActionSnapshot(
                            balls: [
                                Ball(id: 84, state: .loose(square: sq(4, 7)))
                            ],
                            players: [
                                Player(id: pl(.home, 0), spec: .woodElf_lineman, state: .standing(square: sq(3, 0)), canTakeActions: true),
                                Player(id: pl(.home, 1), spec: .woodElf_lineman, state: .standing(square: sq(5, 10)), canTakeActions: true),
                                Player(id: pl(.home, 2), spec: .woodElf_lineman, state: .standing(square: sq(1, 9)), canTakeActions: true),
                                Player(id: pl(.home, 3), spec: .woodElf_passer, state: .standing(square: sq(1, 2)), canTakeActions: true),
                                Player(id: pl(.home, 4), spec: .woodElf_catcher, state: .prone(square: sq(6, 6)), canTakeActions: true),
                                Player(id: pl(.home, 5), spec: .woodElf_wardancer, state: .standing(square: sq(4, 6)), canTakeActions: true),
                                Player(id: pl(.away, 0), spec: .skaven_lineman, state: .standing(square: sq(1, 7)), canTakeActions: true),
                                Player(id: pl(.away, 1), spec: .skaven_lineman, state: .standing(square: sq(6, 5)), canTakeActions: true),
                                Player(id: pl(.away, 2), spec: .skaven_lineman, state: .standing(square: sq(1, 8)), canTakeActions: true),
                                Player(id: pl(.away, 3), spec: .skaven_passer, state: .inReserves, canTakeActions: true),
                                Player(id: pl(.away, 4), spec: .skaven_gutterRunner, state: .inReserves, canTakeActions: true),
                                Player(id: pl(.away, 5), spec: .skaven_blitzer, state: .standing(square: sq(6, 0)), canTakeActions: true),
                            ]
                        )
                    ),
                    .runValidSquares(
                        maxDistance: 8,
                        validSquares: ValidMoveSquares(
                            intermediate: [sq(8, 12), sq(8, 0), sq(2, 14), sq(3, 3), sq(2, 4), sq(4, 0), sq(6, 3), sq(10, 8), sq(6, 13), sq(10, 2), sq(5, 11), sq(3, 8), sq(9, 3), sq(10, 14), sq(4, 2), sq(0, 2), sq(1, 1), sq(9, 4), sq(4, 7), sq(2, 0), sq(7, 13), sq(2, 2), sq(10, 11), sq(3, 4), sq(3, 11), sq(4, 4), sq(4, 10), sq(5, 8), sq(4, 12), sq(3, 10), sq(8, 11), sq(2, 10), sq(4, 8), sq(9, 7), sq(10, 12), sq(7, 11), sq(1, 4), sq(6, 10), sq(1, 14), sq(4, 3), sq(4, 13), sq(3, 6), sq(0, 5), sq(1, 11), sq(8, 3), sq(1, 5), sq(3, 5), sq(9, 8), sq(9, 9), sq(7, 7), sq(5, 9), sq(10, 1), sq(10, 0), sq(1, 13), sq(9, 5), sq(8, 14), sq(8, 7), sq(6, 8), sq(2, 1), sq(4, 1), sq(0, 0), sq(6, 9), sq(3, 13), sq(9, 13), sq(1, 0), sq(9, 1), sq(5, 3), sq(2, 11), sq(7, 8), sq(0, 4), sq(5, 2), sq(10, 13), sq(8, 13), sq(2, 3), sq(0, 1), sq(9, 14), sq(5, 7), sq(0, 3), sq(10, 10), sq(6, 7), sq(1, 10), sq(7, 9), sq(8, 1), sq(7, 10), sq(8, 2), sq(9, 6), sq(8, 10), sq(10, 5), sq(8, 6), sq(8, 8), sq(3, 1), sq(4, 9), sq(9, 0), sq(9, 11), sq(2, 13), sq(7, 3), sq(3, 7), sq(1, 12), sq(0, 11), sq(9, 10), sq(4, 6), sq(10, 6), sq(5, 12), sq(6, 12), sq(3, 14), sq(10, 4), sq(10, 7), sq(10, 3), sq(6, 2), sq(0, 12), sq(5, 13), sq(4, 11), sq(8, 4), sq(4, 5), sq(0, 13), sq(9, 2), sq(5, 14), sq(2, 12), sq(9, 12), sq(10, 9), sq(4, 14), sq(0, 14), sq(6, 11), sq(3, 9), sq(0, 10), sq(7, 14), sq(1, 3), sq(6, 14)],
                            final: [sq(5, 12), sq(4, 14), sq(5, 9), sq(6, 4), sq(0, 13), sq(10, 6), sq(5, 11), sq(7, 14), sq(2, 6), sq(3, 4), sq(7, 8), sq(0, 0), sq(6, 10), sq(1, 5), sq(3, 9), sq(9, 2), sq(9, 13), sq(6, 11), sq(4, 8), sq(1, 1), sq(3, 10), sq(5, 5), sq(9, 6), sq(9, 12), sq(2, 3), sq(0, 9), sq(10, 13), sq(0, 14), sq(0, 3), sq(1, 4), sq(4, 1), sq(0, 2), sq(5, 7), sq(7, 5), sq(8, 6), sq(3, 1), sq(9, 0), sq(10, 0), sq(6, 13), sq(3, 5), sq(8, 8), sq(8, 10), sq(9, 3), sq(1, 10), sq(10, 9), sq(2, 13), sq(4, 13), sq(10, 11), sq(5, 8), sq(8, 0), sq(10, 10), sq(9, 9), sq(9, 7), sq(5, 1), sq(7, 9), sq(10, 1), sq(0, 12), sq(1, 13), sq(1, 6), sq(1, 12), sq(2, 2), sq(2, 14), sq(2, 0), sq(4, 0), sq(9, 4), sq(0, 1), sq(5, 13), sq(10, 12), sq(7, 4), sq(2, 11), sq(5, 6), sq(7, 10), sq(1, 14), sq(0, 4), sq(5, 2), sq(6, 8), sq(10, 14), sq(8, 12), sq(0, 10), sq(9, 10), sq(2, 10), sq(8, 7), sq(0, 11), sq(8, 1), sq(8, 13), sq(1, 0), sq(9, 14), sq(4, 11), sq(6, 3), sq(6, 9), sq(4, 7), sq(4, 3), sq(1, 3), sq(4, 9), sq(6, 2), sq(3, 8), sq(10, 8), sq(10, 2), sq(3, 11), sq(8, 4), sq(4, 5), sq(5, 3), sq(7, 7), sq(7, 3), sq(9, 11), sq(3, 6), sq(8, 3), sq(1, 11), sq(3, 13), sq(7, 13), sq(9, 8), sq(0, 6), sq(4, 6), sq(5, 14), sq(2, 4), sq(8, 11), sq(0, 5), sq(2, 7), sq(3, 3), sq(4, 2), sq(4, 10), sq(8, 2), sq(7, 11), sq(6, 12), sq(10, 7), sq(10, 5), sq(8, 14), sq(10, 4), sq(9, 1), sq(4, 4), sq(10, 3), sq(5, 4), sq(9, 5), sq(4, 12), sq(7, 1), sq(3, 7), sq(5, 0), sq(2, 8), sq(2, 1), sq(7, 0), sq(6, 1), sq(2, 12), sq(3, 14), sq(6, 14), sq(7, 6), sq(6, 7)]
                        )
                    )
                ]
            ),
            previousAddressedPrompt: AddressedPrompt(
                coachID: .home,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.home, 5),
                        square: sq(4, 6)
                    ),
                    maxDistance: 8,
                    validSquares: ValidMoveSquares(
                        intermediate: Set([sq(8, 12), sq(8, 0), sq(2, 14), sq(3, 3), sq(2, 4), sq(4, 0), sq(6, 3), sq(10, 8), sq(6, 13), sq(10, 2), sq(5, 11), sq(3, 8), sq(9, 3), sq(10, 14), sq(4, 2), sq(0, 2), sq(1, 1), sq(9, 4), sq(4, 7), sq(2, 0), sq(7, 13), sq(2, 2), sq(10, 11), sq(3, 4), sq(3, 11), sq(4, 4), sq(4, 10), sq(5, 8), sq(4, 12), sq(3, 10), sq(8, 11), sq(2, 10), sq(4, 8), sq(9, 7), sq(10, 12), sq(7, 11), sq(1, 4), sq(6, 10), sq(1, 14), sq(4, 3), sq(4, 13), sq(3, 6), sq(0, 5), sq(1, 11), sq(8, 3), sq(1, 5), sq(3, 5), sq(9, 8), sq(9, 9), sq(7, 7), sq(5, 9), sq(10, 1), sq(10, 0), sq(1, 13), sq(9, 5), sq(8, 14), sq(8, 7), sq(6, 8), sq(2, 1), sq(4, 1), sq(0, 0), sq(6, 9), sq(3, 13), sq(9, 13), sq(1, 0), sq(9, 1), sq(5, 3), sq(2, 11), sq(7, 8), sq(0, 4), sq(5, 2), sq(10, 13), sq(8, 13), sq(2, 3), sq(0, 1), sq(9, 14), sq(5, 7), sq(0, 3), sq(10, 10), sq(6, 7), sq(1, 10), sq(7, 9), sq(8, 1), sq(7, 10), sq(8, 2), sq(9, 6), sq(8, 10), sq(10, 5), sq(8, 6), sq(8, 8), sq(3, 1), sq(4, 9), sq(9, 0), sq(9, 11), sq(2, 13), sq(7, 3), sq(3, 7), sq(1, 12), sq(0, 11), sq(9, 10), sq(4, 6), sq(10, 6), sq(5, 12), sq(6, 12), sq(3, 14), sq(10, 4), sq(10, 7), sq(10, 3), sq(6, 2), sq(0, 12), sq(5, 13), sq(4, 11), sq(8, 4), sq(4, 5), sq(0, 13), sq(9, 2), sq(5, 14), sq(2, 12), sq(9, 12), sq(10, 9), sq(4, 14), sq(0, 14), sq(6, 11), sq(3, 9), sq(0, 10), sq(7, 14), sq(1, 3), sq(6, 14)]),
                        final: Set([sq(5, 12), sq(4, 14), sq(5, 9), sq(6, 4), sq(0, 13), sq(10, 6), sq(5, 11), sq(7, 14), sq(2, 6), sq(3, 4), sq(7, 8), sq(0, 0), sq(6, 10), sq(1, 5), sq(3, 9), sq(9, 2), sq(9, 13), sq(6, 11), sq(4, 8), sq(1, 1), sq(3, 10), sq(5, 5), sq(9, 6), sq(9, 12), sq(2, 3), sq(0, 9), sq(10, 13), sq(0, 14), sq(0, 3), sq(1, 4), sq(4, 1), sq(0, 2), sq(5, 7), sq(7, 5), sq(8, 6), sq(3, 1), sq(9, 0), sq(10, 0), sq(6, 13), sq(3, 5), sq(8, 8), sq(8, 10), sq(9, 3), sq(1, 10), sq(10, 9), sq(2, 13), sq(4, 13), sq(10, 11), sq(5, 8), sq(8, 0), sq(10, 10), sq(9, 9), sq(9, 7), sq(5, 1), sq(7, 9), sq(10, 1), sq(0, 12), sq(1, 13), sq(1, 6), sq(1, 12), sq(2, 2), sq(2, 14), sq(2, 0), sq(4, 0), sq(9, 4), sq(0, 1), sq(5, 13), sq(10, 12), sq(7, 4), sq(2, 11), sq(5, 6), sq(7, 10), sq(1, 14), sq(0, 4), sq(5, 2), sq(6, 8), sq(10, 14), sq(8, 12), sq(0, 10), sq(9, 10), sq(2, 10), sq(8, 7), sq(0, 11), sq(8, 1), sq(8, 13), sq(1, 0), sq(9, 14), sq(4, 11), sq(6, 3), sq(6, 9), sq(4, 7), sq(4, 3), sq(1, 3), sq(4, 9), sq(6, 2), sq(3, 8), sq(10, 8), sq(10, 2), sq(3, 11), sq(8, 4), sq(4, 5), sq(5, 3), sq(7, 7), sq(7, 3), sq(9, 11), sq(3, 6), sq(8, 3), sq(1, 11), sq(3, 13), sq(7, 13), sq(9, 8), sq(0, 6), sq(4, 6), sq(5, 14), sq(2, 4), sq(8, 11), sq(0, 5), sq(2, 7), sq(3, 3), sq(4, 2), sq(4, 10), sq(8, 2), sq(7, 11), sq(6, 12), sq(10, 7), sq(10, 5), sq(8, 14), sq(10, 4), sq(9, 1), sq(4, 4), sq(10, 3), sq(5, 4), sq(9, 5), sq(4, 12), sq(7, 1), sq(3, 7), sq(5, 0), sq(2, 8), sq(2, 1), sq(7, 0), sq(6, 1), sq(2, 12), sq(3, 14), sq(6, 14), sq(7, 6), sq(6, 7)])
                    )
                )
            )
        )

        // Select run

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .runActionSelectSquares(squares: [
                    sq(4, 7),
                    sq(3, 6),
                    sq(3, 5),
                    sq(3, 4),
                    sq(2, 3),
                    sq(2, 2),
                    sq(1, 1),
                    sq(1, 0),
                ])
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .playerMoved,
                .playerPickedUpLooseBall,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
                .playerMoved,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .earnedObjective)

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .claimObjective(objectiveIndex: 0)
            )
        )

        #expect(
            latestEvents.map { $0.case } == [
                .claimedObjective,
                .scoreUpdated,
                .playerScoredTouchdown,
                .scoreUpdated,
            ]
        )

        #expect(latestAddressedPrompt?.coachID == .home)
        #expect(latestAddressedPrompt?.prompt.case == .declarePlayerAction)
    }
}
