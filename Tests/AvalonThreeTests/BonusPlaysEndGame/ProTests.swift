//
//  ProTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct ProTests {

    @Test func usedForSuccessfulPass() async throws {

        // MARK: - Init

        let d8Randomizer = D8RandomizerDouble()

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
                        coinFlipLoserTeamID: .elf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .elf_lineman,
                            state: .standing(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .elf_lineman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .pro),
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
                d8: d8Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare pass

        var (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(1, 1)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(3, 6),
                            distance: .long,
                            obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .passActionEligibleForProBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Use bonus play

        d8Randomizer.nextResults = [5]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseProBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .pro
                    ),
                    hand: []
                ),
                .rolledForPass(
                    coachID: .away,
                    die: .d8,
                    unmodified: 5
                ),
                .changedPassResult(
                    die: .d8,
                    unmodified: 5,
                    modified: 4,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(1, 1),
                    to: sq(3, 6),
                    angle: 158,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(3, 6),
                    ballID: 123
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .pro
                    )
                ),
                .updatedDiscards(top: .pro, count: 1),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

    @Test func declinedForPass() async throws {

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
                        coinFlipLoserTeamID: .elf
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .elf_lineman,
                            state: .standing(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .elf_lineman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .pro),
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

        var (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(1, 1)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: pl(.away, 1),
                            targetSquare: sq(3, 6),
                            distance: .long,
                            obstructingSquares: [sq(2, 3), sq(1, 3), sq(1, 4), sq(2, 4)],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: pl(.away, 1))
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .passActionEligibleForProBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Decline bonus play

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionDeclineProBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .changedPassResult(
                    die: .d6,
                    unmodified: 5,
                    modified: 4,
                    modifications: [
                        .longDistance, .obstructed,
                    ]
                ),
                .playerPassedBall(
                    playerID: pl(.away, 0),
                    from: sq(1, 1),
                    to: sq(3, 6),
                    angle: 158,
                    ballID: 123
                ),
                .playerCaughtPass(
                    playerID: pl(.away, 1),
                    in: sq(3, 6),
                    ballID: 123
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

    @Test func usedForHurlTeammate() async throws {

        // MARK: - Init

        let d8Randomizer = D8RandomizerDouble()

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
                        coinFlipLoserTeamID: .ogre
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .ogre_ogre,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .ogre_gnoblar,
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .pro),
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
                d8: d8Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .short, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .short, obstructingSquares: [sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3), sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 11), sq(2, 10), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(9, 10), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(8, 4), sq(9, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .short, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 10), sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(9, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: []),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(1, 6))
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionEligibleForProBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Use bonus play

        d8Randomizer.nextResults = [5]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionUseProBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .pro
                    ),
                    hand: []
                ),
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d8,
                    unmodified: 5
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(2, 7),
                    to: sq(1, 6),
                    angle: 315
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    in: sq(1, 6)
                ),
                .discardedActiveBonusPlay(
                    coachID: .away,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .pro
                    )
                ),
                .updatedDiscards(top: .pro, count: 1),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

    @Test func declinedForHurlTeammate() async throws {

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
                        coinFlipLoserTeamID: .ogre
                    ),
                    players: [
                        Player(
                            id: pl(.away, 0),
                            spec: .ogre_ogre,
                            state: .standing(square: sq(2, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.away, 1),
                            spec: .ogre_gnoblar,
                            state: .standing(square: sq(3, 7)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .pro),
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

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(2, 7)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTarget(
                    playerID: pl(.away, 0),
                    validTargets: [
                        HurlTeammateTarget(targetSquare: sq(0, 0), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 1), distance: .long, obstructingSquares: [sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 10), distance: .short, obstructingSquares: [sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 11), distance: .short, obstructingSquares: [sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 13), distance: .long, obstructingSquares: [sq(1, 10), sq(1, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(0, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(1, 11), sq(1, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(0, 2), distance: .long, obstructingSquares: [sq(1, 3), sq(1, 4), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 3), distance: .short, obstructingSquares: [sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(0, 4), distance: .short, obstructingSquares: [sq(1, 4)]),
                        HurlTeammateTarget(targetSquare: sq(0, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(0, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3), sq(1, 4), sq(1, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(1, 4), sq(1, 3), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(1, 12), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 13), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10), sq(1, 10), sq(1, 11)]),
                        HurlTeammateTarget(targetSquare: sq(1, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(1, 11), sq(2, 10), sq(1, 10)]),
                        HurlTeammateTarget(targetSquare: sq(1, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(1, 4), sq(1, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(1, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(1, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 10), distance: .long, obstructingSquares: [sq(9, 10), sq(8, 10)]),
                        HurlTeammateTarget(targetSquare: sq(10, 4), distance: .long, obstructingSquares: [sq(8, 4), sq(9, 4)]),
                        HurlTeammateTarget(targetSquare: sq(10, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(10, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 1), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(2, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(2, 2), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(2, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(2, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 1), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 10), distance: .short, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 11), distance: .short, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(3, 12), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 13), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 14), distance: .long, obstructingSquares: [sq(2, 10), sq(2, 11)]),
                        HurlTeammateTarget(targetSquare: sq(3, 2), distance: .long, obstructingSquares: [sq(2, 3), sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 3), distance: .short, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(3, 4), distance: .short, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(3, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(3, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 0), distance: .long, obstructingSquares: [sq(2, 4), sq(2, 3)]),
                        HurlTeammateTarget(targetSquare: sq(4, 1), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 11), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 12), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 13), distance: .long, obstructingSquares: [sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 14), distance: .long, obstructingSquares: [sq(2, 11), sq(2, 10)]),
                        HurlTeammateTarget(targetSquare: sq(4, 2), distance: .long, obstructingSquares: [sq(2, 4)]),
                        HurlTeammateTarget(targetSquare: sq(4, 3), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(4, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 10), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 4), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(5, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 5), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 6), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 7), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 8), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(6, 9), distance: .short, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 0), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 10), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 11), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 12), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 14), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 2), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 3), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 4), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(7, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 1), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 12), distance: .long, obstructingSquares: [sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(8, 13), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 2), distance: .long, obstructingSquares: [sq(8, 3)]),
                        HurlTeammateTarget(targetSquare: sq(8, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(8, 9), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 12), distance: .long, obstructingSquares: [sq(9, 11), sq(8, 10), sq(8, 11)]),
                        HurlTeammateTarget(targetSquare: sq(9, 2), distance: .long, obstructingSquares: [sq(8, 3), sq(9, 3), sq(8, 4)]),
                        HurlTeammateTarget(targetSquare: sq(9, 5), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 6), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 7), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 8), distance: .long, obstructingSquares: []),
                        HurlTeammateTarget(targetSquare: sq(9, 9), distance: .long, obstructingSquares: []),
                    ]
                )
            )
        )

        // MARK: - Specify target square

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(1, 6))
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionEligibleForProBonusPlay(
                    playerID: pl(.away, 0)
                )
            )
        )

        // MARK: - Use bonus play

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionDeclineProBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(
                    coachID: .away,
                    die: .d6,
                    unmodified: 5
                ),
                .playerHurledTeammate(
                    playerID: pl(.away, 0),
                    teammateID: pl(.away, 1),
                    ballID: 123,
                    from: sq(2, 7),
                    to: sq(1, 6),
                    angle: 315
                ),
                .hurledTeammateLanded(
                    playerID: pl(.away, 1),
                    ballID: 123,
                    in: sq(1, 6)
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

    @Test func usedForArmour() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d8Randomizer = D8RandomizerDouble()

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
                        )
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .pro),
                    ],
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
                d8: d8Randomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare block

        blockDieRandomizer.nextResults = [.smash]

        var (latestEvents, latestPrompt) = try game.process(
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
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash]
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
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .blockActionEligibleForProBonusPlay(
                    playerID: pl(.home, 0)
                )
            )
        )

        // MARK: - Use bonus play

        d8Randomizer.nextResults = [4]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionUseProBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .activatedBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .pro
                    ),
                    hand: []
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d8,
                    unmodified: 4
                ),
                .discardedActiveBonusPlay(
                    coachID: .home,
                    card: ChallengeCard(
                        challenge: .breakSomeBones,
                        bonusPlay: .pro
                    )
                ),
                .updatedDiscards(top: .pro, count: 1),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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

    @Test func declinedForArmour() async throws {

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
                            spec: .orc_lineman,
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
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .pro),
                    ],
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

        blockDieRandomizer.nextResults = [.smash]

        var (latestEvents, latestPrompt) = try game.process(
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
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.smash]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .smash,
                    from: [.smash]
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
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .blockActionEligibleForProBonusPlay(
                    playerID: pl(.home, 0)
                )
            )
        )

        // MARK: - Decline bonus play

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .blockActionDeclineProBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .rolledForArmour(coachID: .home, die: .d6, unmodified: 4),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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
