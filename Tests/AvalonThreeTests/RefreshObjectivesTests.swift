//
//  RefreshObjectivesTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct RefreshObjectivesTests {

    @Test func notPromptedWhenEmptyObjectivesBecauseOneClaimed() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let foulDieRandomizer = FoulDieRandomizerDouble()

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
                            state: .standing(square: sq(5, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .loose(square: sq(2, 2))
                        ),
                    ],
                    deck: [
                        ChallengeCard(
                            challenge: .goDeep,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .lastChance,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .pileOn,
                            bonusPlay: .absoluteCarnage
                        ),
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .showNoFear,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    discards: [
                        ChallengeCard(
                            challenge: .playAsATeam,
                            bonusPlay: .absoluteCarnage
                        ),
                    ]
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
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
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
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(5, 5)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...aaaaa...
                        ...aaaaa...
                        ...aaaaa...
                        ...aaaaa...
                        ...aa.aa...
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaa....
                        ....a.a....
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

        // MARK: - Specify mark

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(5, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(5, 5),
                    to: sq(5, 6),
                    direction: .south,
                    reason: .mark
                )
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare block

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(5, 6)
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
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(5, 7),
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
                    objectiveIDs: [.first]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveID: .first,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ]
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 2,
                    total: 2
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
                                playerID: pl(.away, 0),
                                actionID: .foul
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare foul

        foulDieRandomizer.nextResults = [.spotted]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
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
                        actionID: .foul
                    ),
                    isFree: false,
                    playerSquare: sq(5, 6)
                ),
                .rolledForFoul(
                    coachID: .away,
                    result: .spotted
                ),
                .playerFouled(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerSentOff(
                    playerID: pl(.away, 0),
                    from: sq(5, 6)
                ),
                .turnEnded(coachID: .away),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: .goDeep
                ),
                .updatedDeck(top: .lastChance, count: 2),
                .turnBegan(
                    coachID: .home,
                    isFinal: false
                ),
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
                                actionID: .standUp
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(
            game.table.objectives.first ==
            ChallengeCard(challenge: .goDeep, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .spreadOut, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.objectives.third ==
            ChallengeCard(challenge: .showNoFear, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.coinFlipLoserHand == [
                ChallengeCard(
                    challenge: .takeThemDown,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == [
                ChallengeCard(
                    challenge: .lastChance,
                    bonusPlay: .absoluteCarnage
                ),
                ChallengeCard(
                    challenge: .pileOn,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
        #expect(
            game.table.discards == [
                ChallengeCard(
                    challenge: .playAsATeam,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
    }

    @Test func promptedWhenEmptyObjectivesBecauseSomeMissing() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let foulDieRandomizer = FoulDieRandomizerDouble()

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
                            state: .standing(square: sq(5, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .loose(square: sq(2, 2))
                        ),
                    ],
                    deck: [
                        ChallengeCard(
                            challenge: .goDeep,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .lastChance,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .pileOn,
                            bonusPlay: .absoluteCarnage
                        ),
                    ],
                    objectives: Objectives(
                        second: ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .showNoFear,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    discards: [
                        ChallengeCard(
                            challenge: .playAsATeam,
                            bonusPlay: .absoluteCarnage
                        ),
                    ]
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
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
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
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(5, 5)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...aaaaa...
                        ...aaaaa...
                        ...aaaaa...
                        ...aaaaa...
                        ...aa.aa...
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaa....
                        ....a.a....
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

        // MARK: - Specify mark

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(5, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(5, 5),
                    to: sq(5, 6),
                    direction: .south,
                    reason: .mark
                )
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare block

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(5, 6)
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
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(5, 7),
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
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare foul

        foulDieRandomizer.nextResults = [.spotted]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
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
                        actionID: .foul
                    ),
                    isFree: false,
                    playerSquare: sq(5, 6)
                ),
                .rolledForFoul(
                    coachID: .away,
                    result: .spotted
                ),
                .playerFouled(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerSentOff(
                    playerID: pl(.away, 0),
                    from: sq(5, 6)
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.second, .third])
            )
        )

        // MARK: - Try to preempt the prompt by declaring an action instead

        #expect(throws: GameError("Invalid message")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .home,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: pl(.home, 0),
                            actionID: .standUp
                        ),
                    consumesBonusPlays: []
                    )
                )
            )
        }

        // MARK: - Try to discard an invalid action

        #expect(throws: GameError("Invalid objective ID")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .home,
                    message: .selectObjectiveToDiscard(objectiveID: .first)
                )
            )
        }

        // MARK: - Choose objective to discard

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: ChallengeCard(
                        challenge: .spreadOut,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 2
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .first,
                    objective: .goDeep
                ),
                .updatedDeck(top: .lastChance, count: 2),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: .lastChance
                ),
                .updatedDeck(top: .pileOn, count: 1),
                .turnBegan(
                    coachID: .home,
                    isFinal: false
                ),
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
                                actionID: .standUp
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(
            game.table.objectives.first ==
            ChallengeCard(challenge: .goDeep, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .lastChance, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.objectives.third ==
            ChallengeCard(challenge: .showNoFear, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.coinFlipLoserHand == []
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == [
                ChallengeCard(
                    challenge: .pileOn,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
        #expect(
            game.table.discards == [
                ChallengeCard(
                    challenge: .playAsATeam,
                    bonusPlay: .absoluteCarnage
                ),
                ChallengeCard(
                    challenge: .spreadOut,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
    }

    @Test func promptedWhenNoEmptyObjectives() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()
        let foulDieRandomizer = FoulDieRandomizerDouble()

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
                            state: .standing(square: sq(5, 5)),
                            canTakeActions: true
                        ),
                        Player(
                            id: pl(.home, 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
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
                    balls: [
                        Ball(
                            id: ballID,
                            state: .loose(square: sq(2, 2))
                        ),
                    ],
                    deck: [
                        ChallengeCard(
                            challenge: .goDeep,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .lastChance,
                            bonusPlay: .absoluteCarnage
                        ),
                        ChallengeCard(
                            challenge: .pileOn,
                            bonusPlay: .absoluteCarnage
                        ),
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .showboatForTheCrowd,
                            bonusPlay: .absoluteCarnage
                        ),
                        second: ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .absoluteCarnage
                        ),
                        third: ChallengeCard(
                            challenge: .showNoFear,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    discards: [
                        ChallengeCard(
                            challenge: .playAsATeam,
                            bonusPlay: .absoluteCarnage
                        ),
                    ]
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
                foulDie: foulDieRandomizer
            ),
            ballIDProvider: DefaultBallIDProvider()
        )

        // MARK: - Declare mark

        var (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .mark
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
                        actionID: .mark
                    ),
                    isFree: false,
                    playerSquare: sq(5, 5)
                )
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .away,
                payload: .markActionSpecifySquares(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...aaaaa...
                        ...aaaaa...
                        ...aaaaa...
                        ...aaaaa...
                        ...aa.aa...
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ....aaa....
                        ....a.a....
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

        // MARK: - Specify mark

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSpecifySquares(squares: [
                    sq(5, 6)
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: nil,
                    from: sq(5, 5),
                    to: sq(5, 6),
                    direction: .south,
                    reason: .mark
                )
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
                                actionID: .block
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: pl(.away, 0),
                                actionID: .sidestep
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // MARK: - Declare block

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [6]

        (latestEvents, latestPrompt) = try game.process(
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
                    playerSquare: sq(5, 6)
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
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    in: sq(5, 7),
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
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare foul

        foulDieRandomizer.nextResults = [.spotted]

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
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
                        actionID: .foul
                    ),
                    isFree: false,
                    playerSquare: sq(5, 6)
                ),
                .rolledForFoul(
                    coachID: .away,
                    result: .spotted
                ),
                .playerFouled(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0)
                ),
                .playerSentOff(
                    playerID: pl(.away, 0),
                    from: sq(5, 6)
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestPrompt == Prompt(
                coachID: .home,
                payload: .selectObjectiveToDiscard(objectiveIDs: [.first, .second, .third])
            )
        )

        // MARK: - Try to preempt the prompt by declaring an action instead

        #expect(throws: GameError("Invalid message")) {
            (latestEvents, latestPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .home,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: pl(.home, 0),
                            actionID: .standUp
                        ),
                    consumesBonusPlays: []
                    )
                )
            )
        }

        // MARK: - Choose objective to discard

        (latestEvents, latestPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: ChallengeCard(
                        challenge: .spreadOut,
                        bonusPlay: .absoluteCarnage
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 2
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveID: .second,
                    objective: .goDeep
                ),
                .updatedDeck(top: .lastChance, count: 2),
                .turnBegan(
                    coachID: .home,
                    isFinal: false
                ),
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
                                actionID: .standUp
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 3
                )
            )
        )

        #expect(
            game.table.objectives.first ==
            ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.objectives.second ==
            ChallengeCard(challenge: .goDeep, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.objectives.third ==
            ChallengeCard(challenge: .showNoFear, bonusPlay: .absoluteCarnage)
        )
        #expect(
            game.table.coinFlipLoserHand == []
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == [
                ChallengeCard(
                    challenge: .lastChance,
                    bonusPlay: .absoluteCarnage
                ),
                ChallengeCard(
                    challenge: .pileOn,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
        #expect(
            game.table.discards == [
                ChallengeCard(
                    challenge: .playAsATeam,
                    bonusPlay: .absoluteCarnage
                ),
                ChallengeCard(
                    challenge: .spreadOut,
                    bonusPlay: .absoluteCarnage
                ),
            ]
        )
    }
}
