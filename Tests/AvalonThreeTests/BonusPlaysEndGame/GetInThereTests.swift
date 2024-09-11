//
//  GetInThereTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct GetInThereTests {

    @Test func usedAfterFallingThroughTrapdoorAtBeginningOfPlayersTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        let newBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [newBallID]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
                .turnEnded(coachID: .away),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .trapdoor),
                .newBallAppeared(ballID: newBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: newBallID, to: sq(4, 6))
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 0),
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
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(3, 14),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func declinedAfterFallingThroughTrapdoorAtBeginningOfPlayersTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        let newBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [newBallID]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
                .turnEnded(coachID: .away),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .trapdoor),
                .newBallAppeared(ballID: newBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: newBallID, to: sq(4, 6))
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func usedAfterFallingThroughTrapdoorAtBeginningOfOpponentsTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        let newBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [newBallID]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
                .turnEnded(coachID: .away),
                .playerInjured(playerID: PlayerID(coachID: .away, index: 1), reason: .trapdoor),
                .newBallAppeared(ballID: newBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: newBallID, to: sq(4, 6))
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .away, index: 1),
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

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(3, 0),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .getInThere),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func declinedAfterFallingThroughTrapdoorAtBeginningOfOpponentsTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        let newBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [newBallID]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
                .turnEnded(coachID: .away),
                .playerInjured(playerID: PlayerID(coachID: .away, index: 1), reason: .trapdoor),
                .newBallAppeared(ballID: newBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: newBallID, to: sq(4, 6))
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func usedAfterFallingThroughTrapdoorDuringPlayersTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .showThemHowItsDone, bonusPlay: .multiBall)
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )

        // MARK: - Claim objective

        let firstNewBallID = DefaultUUIDProvider().generate()
        let secondNewBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [firstNewBallID, secondNewBallID]
        directionRandomizer.nextResults = [.northWest, .east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .first),
                .scoreUpdated(coachID: .away, increment: 2),
                .revealedInstantBonusPlay(coachID: .away, bonusPlay: .multiBall),
                .playerInjured(playerID: PlayerID(coachID: .away, index: 1), reason: .trapdoor),
                .newBallAppeared(ballID: firstNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: firstNewBallID, to: sq(4, 6)),
                .newBallAppeared(ballID: secondNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .east),
                .ballBounced(ballID: secondNewBallID, to: sq(6, 7)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .away, index: 1),
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

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(3, 0),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .getInThere),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func declinedAfterFallingThroughTrapdoorDuringPlayersTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .showThemHowItsDone, bonusPlay: .multiBall)
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaaaaaaaaa
                        aaaaa.aaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )

        // MARK: - Claim objective

        let firstNewBallID = DefaultUUIDProvider().generate()
        let secondNewBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [firstNewBallID, secondNewBallID]
        directionRandomizer.nextResults = [.northWest, .east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .first),
                .scoreUpdated(coachID: .away, increment: 2),
                .revealedInstantBonusPlay(coachID: .away, bonusPlay: .multiBall),
                .playerInjured(playerID: PlayerID(coachID: .away, index: 1), reason: .trapdoor),
                .newBallAppeared(ballID: firstNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: firstNewBallID, to: sq(4, 6)),
                .newBallAppeared(ballID: secondNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .east),
                .ballBounced(ballID: secondNewBallID, to: sq(6, 7)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func usedAfterFallingThroughTrapdoorDuringOpponentsTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .showThemHowItsDone, bonusPlay: .multiBall)
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )

        // MARK: - Claim objective

        let firstNewBallID = DefaultUUIDProvider().generate()
        let secondNewBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [firstNewBallID, secondNewBallID]
        directionRandomizer.nextResults = [.northWest, .east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .first),
                .scoreUpdated(coachID: .away, increment: 2),
                .revealedInstantBonusPlay(coachID: .away, bonusPlay: .multiBall),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .trapdoor),
                .newBallAppeared(ballID: firstNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: firstNewBallID, to: sq(4, 6)),
                .newBallAppeared(ballID: secondNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .east),
                .ballBounced(ballID: secondNewBallID, to: sq(6, 7)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 0),
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
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(3, 14),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func declinedAfterFallingThroughTrapdoorDuringOpponentsTurn() async throws {

        // MARK: - Init

        let directionRandomizer = DirectionRandomizerDouble()

        let uuidProvider = UUIDProviderDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(5, 7)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 1),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(1, 1)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(challenge: .showThemHowItsDone, bonusPlay: .multiBall)
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    ),
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .mark
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                    .actionDeclaration(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .sidestep
                        ),
                        snapshot: ActionSnapshot(balls: [], players: [])
                    ),
                    .actionFinished,
                ]
            ),
            previousPrompt: Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [],
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                direction: directionRandomizer
            ),
            uuidProvider: uuidProvider
        )

        // MARK: - Declare run

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .run
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .runActionSpecifySquares(
                    playerID: PlayerID(coachID: .away, index: 0),
                    maxRunDistance: 6,
                    validSquares: ValidMoveSquares(
                        intermediate: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """),
                        final: squares("""
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        ...........
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaa...aaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(
                    squares: [
                        sq(5, 13),
                        sq(5, 14),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 13),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 14),
                    reason: .run
                ),
                .playerScoredTouchdown(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .scoreUpdated(coachID: .away, increment: 4),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(objectiveIDs: [.first])
            )
        )

        // MARK: - Claim objective

        let firstNewBallID = DefaultUUIDProvider().generate()
        let secondNewBallID = DefaultUUIDProvider().generate()
        uuidProvider.nextResults = [firstNewBallID, secondNewBallID]
        directionRandomizer.nextResults = [.northWest, .east]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .first),
                .scoreUpdated(coachID: .away, increment: 2),
                .revealedInstantBonusPlay(coachID: .away, bonusPlay: .multiBall),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .trapdoor),
                .newBallAppeared(ballID: firstNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: firstNewBallID, to: sq(4, 6)),
                .newBallAppeared(ballID: secondNewBallID, square: sq(5, 7)),
                .rolledForDirection(direction: .east),
                .ballBounced(ballID: secondNewBallID, to: sq(6, 7)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .turnEnded(coachID: .away)
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForRegenerationSkillStandUpAction(
                    playerID: PlayerID(coachID: .home, index: 1)
                )
            )
        )
    }

    @Test func usedAfterBeingBlocked() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
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
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.kerrunch]),
                .selectedBlockDieResult(result: .kerrunch),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 11)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .rolledForArmour(die: .d6, unmodified: 4),
                .changedArmourResult(die: .d6, modified: 3, modifications: [.kerrunch]),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 0),
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
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(3, 14),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedAfterBeingBlocked() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .standing(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                blockDie: blockDieRandomizer,
                d6: d6Randomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare block

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .block
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
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
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.kerrunch]),
                .selectedBlockDieResult(result: .kerrunch),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 11)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .rolledForArmour(die: .d6, unmodified: 4),
                .changedArmourResult(die: .d6, modified: 3, modifications: [.kerrunch]),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
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

    @Test func usedAfterBeingFouled() async throws {

        // MARK: - Init

        let foulDieRandomizer = FoulDieRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare foul

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .foul
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .foulActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
                    ]
                )
            )
        )

        // MARK: - Specify foul

        foulDieRandomizer.nextResults = [.gotThem]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .foulActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForFoul(result: .gotThem),
                .playerFouled(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 11)
                ),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .fouled),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .home, index: 0),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .home, index: 0),
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
                        aaaaaaaaaaa
                        """)
                    )
                )
            )
        )

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .reservesActionSpecifySquare(square: sq(3, 14))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .home, index: 0),
                    square: sq(3, 14),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .home, bonusPlay: .getInThere),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .mark
                            ),
                            consumesBonusPlays: []
                        ),
                    ],
                    playerActionsLeft: 2
                )
            )
        )
    }

    @Test func declinedAfterBeingFouled() async throws {

        // MARK: - Init

        let foulDieRandomizer = FoulDieRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .undead,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .human
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(5, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .undead_skeleton,
                            state: .prone(square: sq(5, 11)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere),
                    ],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 0))
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
                    playerActionsLeft: 1
                )
            ),
            randomizers: Randomizers(
                foulDie: foulDieRandomizer
            ),
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare foul

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .foul
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .foulActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PlayerID(coachID: .home, index: 0)
                    ]
                )
            )
        )

        // MARK: - Specify foul

        foulDieRandomizer.nextResults = [.gotThem]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .foulActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForFoul(result: .gotThem),
                .playerFouled(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(5, 11)
                ),
                .playerInjured(playerID: PlayerID(coachID: .home, index: 0), reason: .fouled),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .home, index: 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .home,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
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

    @Test func usedAfterBeingFumbled() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .halfling
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 1))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .hurlTeammate
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTeammates: [
                        PlayerID(coachID: .away, index: 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: PlayerID(coachID: .away, index: 1)
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
                    playerID: PlayerID(coachID: .away, index: 0),
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
        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(die: .d6, unmodified: 1),
                .playerFumbledTeammate(
                    playerID: PlayerID(coachID: .away, index: 0),
                    teammateID: PlayerID(coachID: .away, index: 1)
                ),
                .playerInjured(playerID: PlayerID(coachID: .away, index: 1), reason: .fumbled),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .west),
                .ballBounced(ballID: ballID, to: sq(2, 6)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .useGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .getInThere),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 1),
                        actionID: .reserves
                    ),
                    isFree: true
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .reservesActionSpecifySquare(
                    playerID: PlayerID(coachID: .away, index: 1),
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

        // MARK: - Specify reserves

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .reservesActionSpecifySquare(square: sq(3, 0))
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 1),
                    square: sq(3, 0),
                    reason: .reserves
                ),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .getInThere),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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

    @Test func declinedAfterBeingFumbled() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        coinFlipWinnerConfig: CoinFlipWinnerConfig(
                            boardSpecID: .whiteWolfHolm,
                            challengeDeckID: .shortStandard,
                            teamID: .human,
                            rawTalentBonusRecipientID: nil
                        ),
                        coinFlipLoserConfig: CoinFlipLoserConfig(
                            teamID: .halfling
                        )
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .halfling_treeman,
                            state: .standing(square: sq(3, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .halfling_catcher,
                            state: .standing(square: sq(4, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 8)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .getInThere)
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .away, index: 1))
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Declare hurl teammate

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .hurlTeammate
                    ),
                    isFree: false
                )
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .hurlTeammateActionSpecifyTeammate(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTeammates: [
                        PlayerID(coachID: .away, index: 1),
                    ]
                )
            )
        )

        // MARK: - Specify teammate

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTeammate(
                    teammate: PlayerID(coachID: .away, index: 1)
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
                    playerID: PlayerID(coachID: .away, index: 0),
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
        directionRandomizer.nextResults = [.west]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .hurlTeammateActionSpecifyTarget(targetSquare: sq(7, 6))
            )
        )

        #expect(
            latestEvents == [
                .rolledForHurlTeammate(die: .d6, unmodified: 1),
                .playerFumbledTeammate(
                    playerID: PlayerID(coachID: .away, index: 0),
                    teammateID: PlayerID(coachID: .away, index: 1)
                ),
                .playerInjured(playerID: PlayerID(coachID: .away, index: 1), reason: .fumbled),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .west),
                .ballBounced(ballID: ballID, to: sq(2, 6)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .eligibleForGetInThereBonusPlayReservesAction(
                    playerID: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declineGetInThereBonusPlayReservesAction
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 0),
                                actionID: .run
                            ),
                            consumesBonusPlays: []
                        ),
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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
}
