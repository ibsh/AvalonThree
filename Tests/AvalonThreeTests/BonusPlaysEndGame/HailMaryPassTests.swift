//
//  HailMaryPassTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct HailMaryPassTests {

    @Test func usedSuccessfullyPreDeclaration() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(9, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Try to declare pass without bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .pass
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        }

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: [.hailMaryPass]
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(9, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 4),
                .changedPassResult(die: .d6, modified: 3, modifications: [.longDistance]),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(9, 6)
                ),
                .playerCaughtPass(playerID: PlayerID(coachID: .away, index: 1)),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
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

    @Test func usedAndFailedPreDeclaration() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(9, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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

        // MARK: - Try to declare pass without bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .pass
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        }

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: [.hailMaryPass]
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(9, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 3),
                .changedPassResult(die: .d6, modified: 2, modifications: [.longDistance]),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(9, 6)
                ),
                .playerFailedCatch(playerID: PlayerID(coachID: .away, index: 1)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .south),
                .ballBounced(ballID: ballID, to: sq(9, 7)),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
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

    @Test func usedAndFumbledPreDeclaration() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .snotling
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .snotling_snotling,
                            state: .standing(square: sq(9, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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

        // MARK: - Try to declare pass without bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .pass
                        ),
                        consumesBonusPlays: []
                    )
                )
            )
        }

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    consumesBonusPlays: [.hailMaryPass]
                )
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
                .declaredAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(9, 6),
                            distance: .long,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [2]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 2),
                .changedPassResult(die: .d6, modified: 1, modifications: [.longDistance]),
                .playerFumbledBall(playerID: PlayerID(coachID: .away, index: 0)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .south),
                .ballBounced(ballID: ballID, to: sq(0, 7)),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
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

    @Test func declinedPostDeclaration() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .darkElf_runner,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Try to declare pass with bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .pass
                        ),
                        consumesBonusPlays: [.hailMaryPass]
                    )
                )
            )
        }

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionEligibleForHailMaryPassBonusPlay(
                    playerID: PlayerID(coachID: .away, index: 0)
                )
            )
        )

        // MARK: - Decline bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionDeclineHailMaryPassBonusPlay
            )
        )

        #expect(
            latestEvents == []
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(2, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 3),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(2, 6)
                ),
                .playerCaughtPass(playerID: PlayerID(coachID: .away, index: 1)),
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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

    @Test func usedSuccessfullyPostDeclarationForAReallyEasyPass() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .darkElf_runner,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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
            uuidProvider: DefaultUUIDProvider()
        )

        // MARK: - Try to declare pass with bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .pass
                        ),
                        consumesBonusPlays: [.hailMaryPass]
                    )
                )
            )
        }

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionEligibleForHailMaryPassBonusPlay(
                    playerID: PlayerID(coachID: .away, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseHailMaryPassBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(2, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [4]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 4),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(2, 6)
                ),
                .playerCaughtPass(playerID: PlayerID(coachID: .away, index: 1)),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
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
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .away, index: 1),
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

    @Test func usedAndFailedPostDeclarationForAReallyEasyPass() async throws {

        // MARK: - Init

        let d6Randomizer = D6RandomizerDouble()
        let directionRandomizer = DirectionRandomizerDouble()

        let ballID = DefaultUUIDProvider().generate()

        var game = Game(
            phase: .active(
                Table(
                    config: FinalizedConfig(
                        coinFlipWinnerCoachID: .home,
                        boardSpecID: .whiteWolfHolm,
                        challengeDeckID: .shortStandard,
                        rookieBonusRecipientID: .noOne,
                        coinFlipWinnerTeamID: .human,
                        coinFlipLoserTeamID: .darkElf
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .darkElf_runner,
                            state: .standing(square: sq(0, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .darkElf_lineman,
                            state: .standing(square: sq(2, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(challenge: .breakSomeBones, bonusPlay: .hailMaryPass)
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

        // MARK: - Try to declare pass with bonus play

        #expect(throws: GameError("No matching declaration")) {
            _ = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .declarePlayerAction(
                        declaration: ActionDeclaration(
                            playerID: PlayerID(coachID: .away, index: 0),
                            actionID: .pass
                        ),
                        consumesBonusPlays: [.hailMaryPass]
                    )
                )
            )
        }

        // MARK: - Declare pass

        var (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .declarePlayerAction(
                    declaration: ActionDeclaration(
                        playerID: PlayerID(coachID: .away, index: 0),
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
                        playerID: PlayerID(coachID: .away, index: 0),
                        actionID: .pass
                    ),
                    isFree: false
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionEligibleForHailMaryPassBonusPlay(
                    playerID: PlayerID(coachID: .away, index: 0)
                )
            )
        )

        // MARK: - Use bonus play

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionUseHailMaryPassBonusPlay
            )
        )

        #expect(
            latestEvents == [
                .revealedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .passActionSpecifyTarget(
                    playerID: PlayerID(coachID: .away, index: 0),
                    validTargets: [
                        PassTarget(
                            targetPlayerID: PlayerID(coachID: .away, index: 1),
                            targetSquare: sq(2, 6),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        ),
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [3]
        directionRandomizer.nextResults = [.south]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(
                    target: PlayerID(coachID: .away, index: 1)
                )
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 3),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(2, 6)
                ),
                .playerFailedCatch(playerID: PlayerID(coachID: .away, index: 1)),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .south),
                .ballBounced(ballID: ballID, to: sq(2, 7)),
                .discardedPersistentBonusPlay(coachID: .away, bonusPlay: .hailMaryPass),
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
}
