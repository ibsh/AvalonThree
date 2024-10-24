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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .markActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(5, 5)
                    ),
                    maxDistance: 2,
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

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .block,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .sidestep,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(6))
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
                    results: BlockResults(dice: [.smash])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.smash])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(5, 7),
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [0],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .takeThemDown, value: 2),
                        second: WrappedObjective(challenge: .spreadOut, value: 1),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 0)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 0,
                    objective: .open(
                        card: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .absoluteCarnage
                        )
                    ),
                    objectives: WrappedObjectives(
                        first: nil,
                        second: WrappedObjective(challenge: .spreadOut, value: 1),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    ),
                    hand: [
                        .open(
                            card: ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .absoluteCarnage
                            )
                        )
                    ],
                    active: []
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 2,
                    total: 2
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
                            square: sq(5, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.spotted))
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
                    playerSquare: sq(5, 6)
                ),
                .turnEnded(coachID: .away),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 0,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .goDeep, value: 2),
                        second: WrappedObjective(challenge: .spreadOut, value: 1),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(
                        challenge: .lastChance,
                        value: 0
                    ),
                    count: 2
                ),
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
                            square: sq(5, 7),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ]
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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .markActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(5, 5)
                    ),
                    maxDistance: 2,
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

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .block,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .sidestep,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(6))
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
                    results: BlockResults(dice: [.smash])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.smash])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(5, 7),
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.spotted))
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
                    playerSquare: sq(5, 6)
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectObjectiveToDiscard(
                    objectives: WrappedObjectives(
                        first: nil,
                        second: WrappedObjective(challenge: .spreadOut, value: 1),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                )
            )
        )

        // Try to preempt the prompt by declaring an action instead

        #expect(throws: GameError("Invalid message")) {
            (latestEvents, latestAddressedPrompt) = try game.process(
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

        // Try to discard an invalid action

        #expect(throws: GameError("Invalid objective ID")) {
            (latestEvents, latestAddressedPrompt) = try game.process(
                InputMessageWrapper(
                    coachID: .home,
                    message: .selectObjectiveToDiscard(objectiveIndex: 0)
                )
            )
        }

        // Choose objective to discard

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objective: ChallengeCard(
                        challenge: .spreadOut,
                        bonusPlay: .absoluteCarnage
                    ),
                    objectives: WrappedObjectives(
                        first: nil,
                        second: nil,
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 2
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 0,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .goDeep, value: 2),
                        second: nil,
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .lastChance, value: 0),
                    count: 2
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .goDeep, value: 2),
                        second: WrappedObjective(challenge: .lastChance, value: 0),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .pileOn, value: 2),
                    count: 1
                ),
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
                            square: sq(5, 7),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ]
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
                            id: 123,
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
            previousAddressedPrompt: AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 3
                )
            )
        )

        // Declare mark

        var (latestEvents, latestAddressedPrompt) = try game.process(
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .markActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(5, 5)
                    ),
                    maxDistance: 2,
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

        // Select mark

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .markActionSelectSquares(squares: [
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .block,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .sidestep,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare block

        (latestEvents, latestAddressedPrompt) = try game.process(
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
            randomizers: Randomizers(blockDie: block(.smash), d6: d6(6))
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
                    results: BlockResults(dice: [.smash])
                ),
                .selectedBlockDieResult(
                    coachID: .away,
                    dieIndex: 0,
                    from: BlockResults(dice: [.smash])
                ),
                .playerBlocked(
                    playerID: pl(.away, 0),
                    from: sq(5, 6),
                    to: sq(5, 7),
                    direction: .south,
                    targetPlayerID: pl(.home, 0),
                    assistingPlayers: []
                ),
                .playerFellDown(
                    playerID: pl(.home, 0),
                    playerSquare: sq(5, 7),
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
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .declarePlayerAction(
                    validDeclarations: [
                        PromptValidDeclaringPlayer(
                            playerID: pl(.away, 0),
                            square: sq(5, 6),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .run,
                                    consumesBonusPlays: []
                                ),
                                PromptValidDeclaration(
                                    actionID: .foul,
                                    consumesBonusPlays: []
                                ),
                            ]
                        ),
                    ],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare foul

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .foul
                    ),
                    consumesBonusPlays: []
                )
            ),
            randomizers: Randomizers(foulDie: foul(.spotted))
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
                    playerSquare: sq(5, 6)
                ),
                .turnEnded(coachID: .away),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .selectObjectiveToDiscard(
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .showboatForTheCrowd, value: 1),
                        second: WrappedObjective(challenge: .spreadOut, value: 1),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                )
            )
        )

        // Try to preempt the prompt by declaring an action instead

        #expect(throws: GameError("Invalid message")) {
            (latestEvents, latestAddressedPrompt) = try game.process(
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

        // Choose objective to discard

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .selectObjectiveToDiscard(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objective: ChallengeCard(
                        challenge: .spreadOut,
                        bonusPlay: .absoluteCarnage
                    ),
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .showboatForTheCrowd, value: 1),
                        second: nil,
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                ),
                .updatedDiscards(
                    top: .absoluteCarnage,
                    count: 2
                ),
                .dealtNewObjective(
                    coachID: .home,
                    objectiveIndex: 1,
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .showboatForTheCrowd, value: 1),
                        second: WrappedObjective(challenge: .goDeep, value: 2),
                        third: WrappedObjective(challenge: .showNoFear, value: 2)
                    )
                ),
                .updatedDeck(
                    top: WrappedObjective(challenge: .lastChance, value: 0),
                    count: 2
                ),
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
                            square: sq(5, 7),
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .standUp,
                                    consumesBonusPlays: []
                                ),
                            ]
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
