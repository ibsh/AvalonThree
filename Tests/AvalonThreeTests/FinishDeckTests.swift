//
//  FinishDeckTests.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 10/17/24.
//

import Testing
@testable import AvalonThree

struct FinishDeckTests {

    private func getToLastTurn() throws -> Game {

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
                            state: .standing(square: sq(6, 10)),
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
                    coinFlipLoserScore: 7,
                    coinFlipWinnerScore: 11,
                    balls: [
                        Ball(
                            id: 123,
                            state: .held(playerID: pl(.away, 0))
                        ),
                    ],
                    deck: [
                    ],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .breakSomeBones, bonusPlay: .stepAside),
                        second: ChallengeCard(challenge: .showNoFear, bonusPlay: .jumpUp),
                        third: ChallengeCard(challenge: .moveTheBall, bonusPlay: .dodge)
                    ),
                    discards: [
                        ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .rawTalent),
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .blockingPlay),
                        ChallengeCard(challenge: .showUsACompletion, bonusPlay: .passingPlay),
                        ChallengeCard(challenge: .showboatForTheCrowd, bonusPlay: .multiBall),
                        ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .intervention),
                        ChallengeCard(challenge: .tieThemUp, bonusPlay: .defensivePlay),
                        ChallengeCard(challenge: .moveTheBall, bonusPlay: .rawTalent),
                        ChallengeCard(challenge: .takeThemDown, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .gangUp, bonusPlay: .toughEnough),
                        ChallengeCard(challenge: .getTheBall, bonusPlay: .distraction),
                        ChallengeCard(challenge: .freeUpTheBall, bonusPlay: .blitz),
                        ChallengeCard(challenge: .getMoving, bonusPlay: .interference),
                        ChallengeCard(challenge: .getTogether, bonusPlay: .reserves),
                        ChallengeCard(challenge: .getMoving, bonusPlay: .sprint),
                        ChallengeCard(challenge: .makeARiskyPass, bonusPlay: .accuratePass),
                        ChallengeCard(challenge: .tieThemUp, bonusPlay: .rawTalent),
                        ChallengeCard(challenge: .spreadOut, bonusPlay: .reserves),
                        ChallengeCard(challenge: .takeThemDown, bonusPlay: .divingTackle),
                        ChallengeCard(challenge: .gangUp, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .showUsACompletion, bonusPlay: .inspiration),
                        ChallengeCard(challenge: .getTheBall, bonusPlay: .shadow),
                    ]
                ),
                [
                    .prepareForTurn(
                        coachID: .home,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.home, 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: pl(.home, 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousAddressedPrompt: AddressedPrompt(
                coachID: .home,
                prompt: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            )
        )

        // Declare run

        var (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.home, 0),
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
                        playerID: pl(.home, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(5, 7)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .home,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.home, 0),
                        square: sq(5, 7)
                    ),
                    maxDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaa...aaa
                        a..aa.....a
                        a..aa.....a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        ...........
                        """),
                        final: squares("""
                        ...........
                        .aaaaaaaaa.
                        .aaaaaaaaa.
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaa...aaa
                        a..aa.....a
                        a..aa.....a
                        .aaaaaa....
                        .aaaaaa....
                        ...........
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .runActionSelectSquares(
                    squares: [
                        sq(4, 7),
                        sq(3, 7),
                        sq(2, 7),
                        sq(1, 7),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(5, 7),
                    to: sq(4, 7),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(4, 7),
                    to: sq(3, 7),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(3, 7),
                    to: sq(2, 7),
                    direction: .west,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.home, 0),
                    ballID: nil,
                    from: sq(2, 7),
                    to: sq(1, 7),
                    direction: .west,
                    reason: .run
                ),
                .turnEnded(coachID: .home),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .selectObjectiveToDiscard(
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: WrappedObjective(challenge: .showNoFear, value: 2),
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Discard objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectObjectiveToDiscard(objectiveIndex: 1)
            )
        )

        #expect(
            latestEvents == [
                .discardedObjective(
                    coachID: .away,
                    objectiveIndex: 1,
                    objective: ChallengeCard(challenge: .showNoFear, bonusPlay: .jumpUp),
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                ),
                .updatedDiscards(
                    top: .jumpUp,
                    count: 22
                ),
                .turnBegan(
                    coachID: .away,
                    isFinal: true
                ),
            ]
        )

        return game
    }

    @Test func gameEndsWithLastMinuteVictory() async throws {

        var game = try getToLastTurn()

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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(6, 10)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 10)
                    ),
                    maxDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        .aaaaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ..aaaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(6, 11),
                        sq(6, 12),
                        sq(6, 13),
                        sq(6, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 10),
                    to: sq(6, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 11),
                    to: sq(6, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 12),
                    to: sq(6, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 13),
                    to: sq(6, 14),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [2],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Claim objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveIndex: 2)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(
                    coachID: .away,
                    objectiveIndex: 2,
                    objective: .open(card: ChallengeCard(challenge: .moveTheBall, bonusPlay: .dodge)),
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: nil
                    ),
                    hand: [
                        .open(card: ChallengeCard(challenge: .moveTheBall, bonusPlay: .dodge))
                    ],
                    active: []
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 1,
                    total: 8
                ),
                .playerScoredTouchdown(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 14),
                    ballID: 123
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 4,
                    total: 12
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
                            square: nil,
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .reserves,
                                    consumesBonusPlays: []
                                )
                            ]
                        )
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .reserves
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
                        actionID: .reserves
                    ),
                    isFree: false,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .reservesActionSelectSquare(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
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
                        aaaaaaaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
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

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSelectSquare(
                    square: sq(6, 0)
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 0),
                    to: sq(6, 0)
                ),
                .gameEnded(
                    endConditions: .clock(coachID: .away)
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == nil
        )
    }

    @Test func gameEndsWithDamnFoolDraw() async throws {

        var game = try getToLastTurn()

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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(6, 10)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 10)
                    ),
                    maxDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        .aaaaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ..aaaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(6, 11),
                        sq(6, 12),
                        sq(6, 13),
                        sq(6, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 10),
                    to: sq(6, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 11),
                    to: sq(6, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 12),
                    to: sq(6, 13),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 13),
                    to: sq(6, 14),
                    direction: .south,
                    reason: .run
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .earnedObjective(
                    indices: [2],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                )
            )
        )

        // Decline objective

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineToClaimObjective
            )
        )

        #expect(
            latestEvents == [
                .declinedObjectives(
                    coachID: .away,
                    indices: [2],
                    objectives: WrappedObjectives(
                        first: WrappedObjective(challenge: .breakSomeBones, value: 3),
                        second: nil,
                        third: WrappedObjective(challenge: .moveTheBall, value: 1)
                    )
                ),
                .playerScoredTouchdown(
                    playerID: pl(.away, 0),
                    playerSquare: sq(6, 14),
                    ballID: 123
                ),
                .scoreUpdated(
                    coachID: .away,
                    increment: 4,
                    total: 11
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
                            square: nil,
                            declarations: [
                                PromptValidDeclaration(
                                    actionID: .reserves,
                                    consumesBonusPlays: []
                                )
                            ]
                        )
                    ],
                    playerActionsLeft: 2
                )
            )
        )

        // Declare reserves

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .reserves
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
                        actionID: .reserves
                    ),
                    isFree: false,
                    playerSquare: nil
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .reservesActionSelectSquare(
                    playerID: pl(.away, 0),
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
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
                        aaaaaaaaaaa
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
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

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSelectSquare(
                    square: sq(6, 0)
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMovedOutOfReserves(
                    playerID: pl(.away, 0),
                    to: sq(6, 0)
                ),
                .gameEnded(
                    endConditions: .tie
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == nil
        )
    }

    @Test func gameEndsWithDamnFoolDefeat() async throws {

        var game = try getToLastTurn()

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
            latestEvents == [
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: pl(.away, 0),
                        actionID: .run
                    ),
                    isFree: false,
                    playerSquare: sq(6, 10)
                )
            ]
        )

        #expect(
            latestAddressedPrompt == AddressedPrompt(
                coachID: .away,
                prompt: .runActionSelectSquares(
                    player: PromptBoardPlayer(
                        id: pl(.away, 0),
                        square: sq(6, 10)
                    ),
                    maxDistance: 5,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        .aaaaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ..aaaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        ...aaaaaaaa
                        .aaaaaaaaaa
                        ...aaaaa..a
                        ...aaaaa..a
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        .aaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // Select run

        (latestEvents, latestAddressedPrompt) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSelectSquares(
                    squares: [
                        sq(6, 11),
                        sq(6, 12),
                        sq(6, 13),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 10),
                    to: sq(6, 11),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 11),
                    to: sq(6, 12),
                    direction: .south,
                    reason: .run
                ),
                .playerMoved(
                    playerID: pl(.away, 0),
                    ballID: 123,
                    from: sq(6, 12),
                    to: sq(6, 13),
                    direction: .south,
                    reason: .run
                ),
                .gameEnded(
                    endConditions: .clock(coachID: .home)
                ),
            ]
        )

        #expect(
            latestAddressedPrompt == nil
        )
    }
}
