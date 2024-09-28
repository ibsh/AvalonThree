//
//  LastChanceTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/1/24.
//

import Testing
@testable import AvalonThree

struct LastChanceTests {

    @Test func notAvailableWhenNotAtLeastFourPointsBehind() async throws {

        // MARK: - Init

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
                            state: .standing(square: sq(3, 10)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 3,
                    balls: [
                        Ball(id: ballID, state: .loose(square: sq(0, 0)))
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .lastChance,
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
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            ),
            randomizers: Randomizers(),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare run

        var (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(3, 10)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: pl(.away, 0),
                    maxRunDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        a..aaaaa...
                        a..aaaaa...
                        aaaaaaaaa..
                        aaaaaaaaa..
                        aaaaaaaaa..
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(4, 10)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(3, 10),
                    to: sq(4, 10),
                    direction: .east,
                    reason: .run
                ),
                .turnEnded(coachID: .away),
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: ChallengeCard(
                        challenge: .lastChance,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 1
                ),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )
    }

    @Test func notAvailableWhenEarningAnotherCard() async throws {

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
                            state: .standing(square: sq(3, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(3, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 8,
                    balls: [],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .lastChance,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .takeThemDown,
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
        d6Randomizer.nextResults = [6]

        let (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(3, 10)
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
                    from: sq(3, 10),
                    to: sq(3, 11),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(3, 11),
                    reason: .blocked
                ),
                .rolledForArmour(
                    coachID: .home,
                    die: .d6,
                    unmodified: 6
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.third]
                )
            )
        )
    }

    @Test func availableWhenAtLeastFourPointsBehindAndNoOtherCardClaimed() async throws {

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
                            state: .standing(square: sq(3, 10)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(3, 11)),
                            canTakeActions: true
                        ),
                    ],
                    playerNumbers: [:],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 4,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .lastChance,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .takeThemDown,
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

        blockDieRandomizer.nextResults = [.miss]

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
                    playerSquare: sq(3, 10)
                ),
                .rolledForBlock(
                    coachID: .away,
                    results: [.miss]
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    result: .miss,
                    from: [.miss]
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(3, 10),
                    to: sq(3, 11),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerCannotTakeActions(
                    playerID: pl(.away, 0),
                    in: sq(3, 10)
                ),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.second]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .second,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .lastChance,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .lastChance,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ]
                ),
                .turnEnded(coachID: .away),
                .playerCanTakeActions(
                    playerID: pl(.away, 0),
                    in: sq(3, 10)
                ),
                .turnBegan(coachID: .home, isFinal: true),
            ]
        )

        #expect(
            latestPrompt == Prompt(
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
}
