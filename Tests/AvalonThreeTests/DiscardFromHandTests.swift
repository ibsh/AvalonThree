//
//  DiscardFromHandTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/3/24.
//

import Testing
@testable import AvalonThree

struct DiscardFromHandTests {

    @Test func notPromptedWhenOnlyHoldingThreeCards() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
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
                        coinFlipLoserTeamID: .undead
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .undead_wight,
                            state: .standing(square: sq(6, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .undead_ghoul,
                            state: .standing(square: sq(6, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 6)),
                            canTakeActions: true
                        ),
                    ],
                    coinFlipLoserHand: [],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .home, index: 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .blitz
                        ),
                        second: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        third: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        )
                    ),
                    discards: []
                ),
                [
                    .prepareForTurn(
                        coachID: .away,
                        isSpecial: nil,
                        mustDiscardObjective: false
                    )
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

        blockDieRandomizer.nextResults = [.smash]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.smash]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: PlayerID(coachID: .away, index: 0),
                    results: [.smash]
                )
            )
        )

        // MARK: - Choose to reroll

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [6]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseOffensiveSpecialistSkillReroll
            )
        )

        #expect(
            latestEvents == [
                .usedOffensiveSpecialistSkillReroll(playerID: PlayerID(coachID: .away, index: 0)),
                .rolledForBlock(results: [.smash]),
                .selectedBlockDieResult(coachID: .away, result: .smash),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(7, 6)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: ballID, to: sq(6, 5)),
                .rolledForArmour(die: .d6, unmodified: 6),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.second]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .second),
                .scoreUpdated(coachID: .away, increment: 2),
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
                                actionID: .foul
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

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaa.aaaa
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ..aaaa.aaaa
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(6, 5),
                    sq(6, 6),
                    sq(6, 7),
                    sq(6, 8),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 5),
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 6),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.first]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .first),
                .scoreUpdated(coachID: .away, increment: 1),
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
                                actionID: .pass
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
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare pass

        (latestEvents, latestPayload) = try game.process(
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
                )
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
                            targetSquare: sq(6, 12),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: PlayerID(coachID: .away, index: 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 5),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 12)
                ),
                .playerCaughtPass(playerID: PlayerID(coachID: .away, index: 1)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.third]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .third),
                .scoreUpdated(coachID: .away, increment: 1),
                .earnedCleanSweep(coachID: .away),
                .scoreUpdated(coachID: .away, increment: 2),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
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
            game.table.objectives.first == nil
        )
        #expect(
            game.table.objectives.second == nil
        )
        #expect(
            game.table.objectives.third == nil
        )
        #expect(
            game.table.coinFlipLoserHand == [
                ChallengeCard(
                    challenge: .takeThemDown,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .getTheBall,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .moveTheBall,
                    bonusPlay: .blitz
                ),
            ]
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == []
        )
        #expect(
            game.table.discards == []
        )
    }

    @Test func mustDiscardCardsYouAreHoldingAndDownToExactlyThreeCards() async throws {

        // MARK: - Init

        let blockDieRandomizer = BlockDieRandomizerDouble()
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
                        coinFlipLoserTeamID: .undead
                    ),
                    players: [
                        Player(
                            id: PlayerID(coachID: .away, index: 0),
                            spec: .undead_wight,
                            state: .standing(square: sq(6, 6)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .away, index: 1),
                            spec: .undead_ghoul,
                            state: .standing(square: sq(6, 12)),
                            canTakeActions: true
                        ),
                        Player(
                            id: PlayerID(coachID: .home, index: 0),
                            spec: .human_lineman,
                            state: .standing(square: sq(7, 6)),
                            canTakeActions: true
                        )
                    ],
                    coinFlipLoserHand: [
                        ChallengeCard(
                            challenge: .tieThemUp,
                            bonusPlay: .blitz
                        ),
                        ChallengeCard(
                            challenge: .spreadOut,
                            bonusPlay: .blitz
                        ),
                    ],
                    coinFlipWinnerHand: [],
                    coinFlipLoserActiveBonuses: [],
                    coinFlipWinnerActiveBonuses: [],
                    coinFlipLoserScore: 0,
                    coinFlipWinnerScore: 0,
                    balls: [
                        Ball(
                            id: ballID,
                            state: .held(playerID: PlayerID(coachID: .home, index: 0))
                        )
                    ],
                    deck: [],
                    objectives: Objectives(
                        first: ChallengeCard(
                            challenge: .getTheBall,
                            bonusPlay: .blitz
                        ),
                        second: ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        third: ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
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
                d6: d6Randomizer,
                direction: directionRandomizer
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

        blockDieRandomizer.nextResults = [.smash]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionSpecifyTarget(target: PlayerID(coachID: .home, index: 0))
            )
        )

        #expect(
            latestEvents == [
                .rolledForBlock(results: [.smash]),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: PlayerID(coachID: .away, index: 0),
                    results: [.smash]
                )
            )
        )

        // MARK: - Choose to reroll

        blockDieRandomizer.nextResults = [.smash]
        d6Randomizer.nextResults = [6]
        directionRandomizer.nextResults = [.northWest]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .blockActionUseOffensiveSpecialistSkillReroll
            )
        )

        #expect(
            latestEvents == [
                .usedOffensiveSpecialistSkillReroll(playerID: PlayerID(coachID: .away, index: 0)),
                .rolledForBlock(results: [.smash]),
                .selectedBlockDieResult(coachID: .away, result: .smash),
                .playerBlocked(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(7, 6)
                ),
                .playerFellDown(playerID: PlayerID(coachID: .home, index: 0), reason: .blocked),
                .ballCameLoose(ballID: ballID),
                .rolledForDirection(direction: .northWest),
                .ballBounced(ballID: ballID, to: sq(6, 5)),
                .rolledForArmour(die: .d6, unmodified: 6),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.second]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .second)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .second),
                .scoreUpdated(coachID: .away, increment: 2),
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
                                actionID: .foul
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

        // MARK: - Declare run

        (latestEvents, latestPayload) = try game.process(
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
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaa.aaaa
                        ...........
                        ...........
                        """),
                        final: squares("""
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        a..aaaaa..a
                        aaaaaaaaaaa
                        aaaaaaa.aaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        aaaaaaaaaaa
                        a..aaaaa..a
                        ...aaaaa..a
                        ..aaaa.aaaa
                        ...........
                        ...........
                        """)
                    )
                )
            )
        )

        // MARK: - Specify run

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .runActionSpecifySquares(squares: [
                    sq(6, 5),
                    sq(6, 6),
                    sq(6, 7),
                    sq(6, 8),
                ])
            )
        )

        #expect(
            latestEvents == [
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 5),
                    reason: .run
                ),
                .playerPickedUpLooseBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    ballID: ballID
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 6),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 7),
                    reason: .run
                ),
                .playerMoved(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 8),
                    reason: .run
                ),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.first]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .first)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .first),
                .scoreUpdated(coachID: .away, increment: 1),
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
                                actionID: .pass
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
                    playerActionsLeft: 1
                )
            )
        )

        // MARK: - Declare pass

        (latestEvents, latestPayload) = try game.process(
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
                )
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
                            targetSquare: sq(6, 12),
                            distance: .short,
                            obstructingSquares: [],
                            markedTargetSquares: []
                        )
                    ]
                )
            )
        )

        // MARK: - Specify pass

        d6Randomizer.nextResults = [5]

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .passActionSpecifyTarget(target: PlayerID(coachID: .away, index: 1))
            )
        )

        #expect(
            latestEvents == [
                .rolledForPass(die: .d6, unmodified: 5),
                .playerPassedBall(
                    playerID: PlayerID(coachID: .away, index: 0),
                    square: sq(6, 12)
                ),
                .playerCaughtPass(playerID: PlayerID(coachID: .away, index: 1)),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .earnedObjective(
                    objectiveIDs: [.third]
                )
            )
        )

        // MARK: - Claim objective

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .claimObjective(objectiveID: .third)
            )
        )

        #expect(
            latestEvents == [
                .claimedObjective(coachID: .away, objectiveID: .third),
                .scoreUpdated(coachID: .away, increment: 1),
                .earnedCleanSweep(coachID: .away),
                .scoreUpdated(coachID: .away, increment: 2),
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .away,
                payload: .selectCardsToDiscardFromHand(cards: [
                    ChallengeCard(
                        challenge: .tieThemUp,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .spreadOut,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .takeThemDown,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .getTheBall,
                        bonusPlay: .blitz
                    ),
                    ChallengeCard(
                        challenge: .moveTheBall,
                        bonusPlay: .blitz
                    ),
                ])
            )
        )

        // MARK: - Specify cards that aren't in hand

        #expect(throws: GameError("Invalid cards")) {
            (latestEvents, latestPayload) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .selectCardsToDiscardFromHand(
                        cards: [
                            ChallengeCard(
                                challenge: .gangUp,
                                bonusPlay: .blitz
                            ),
                            ChallengeCard(
                                challenge: .makeARiskyPass,
                                bonusPlay: .blitz
                            ),
                        ]
                    )
                )
            )
        }

        // MARK: - Specify too few cards

        #expect(throws: GameError("Invalid card count")) {
            (latestEvents, latestPayload) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .selectCardsToDiscardFromHand(
                        cards: [
                            ChallengeCard(
                                challenge: .takeThemDown,
                                bonusPlay: .blitz
                            ),
                        ]
                    )
                )
            )
        }

        // MARK: - Specify too many cards

        #expect(throws: GameError("Invalid card count")) {
            (latestEvents, latestPayload) = try game.process(
                InputMessageWrapper(
                    coachID: .away,
                    message: .selectCardsToDiscardFromHand(
                        cards: [
                            ChallengeCard(
                                challenge: .spreadOut,
                                bonusPlay: .blitz
                            ),
                            ChallengeCard(
                                challenge: .getTheBall,
                                bonusPlay: .blitz
                            ),
                            ChallengeCard(
                                challenge: .moveTheBall,
                                bonusPlay: .blitz
                            ),
                        ]
                    )
                )
            )
        }

        // MARK: - Specify valid cards

        (latestEvents, latestPayload) = try game.process(
            InputMessageWrapper(
                coachID: .away,
                message: .selectCardsToDiscardFromHand(
                    cards: [
                        ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        ),
                    ]
                )
            )
        )

        #expect(
            latestEvents == [
                .discardedCardsFromHand(
                    coachID: .away,
                    cards: [
                        ChallengeCard(
                            challenge: .takeThemDown,
                            bonusPlay: .blitz
                        ),
                        ChallengeCard(
                            challenge: .moveTheBall,
                            bonusPlay: .blitz
                        ),
                    ]
                ),
                .turnEnded(coachID: .away),
                .finalTurnBegan
            ]
        )

        #expect(
            latestPayload == Prompt(
                coachID: .home,
                payload: .declarePlayerAction(
                    validDeclarations: [
                        ValidDeclaration(
                            declaration: ActionDeclaration(
                                playerID: PlayerID(coachID: .home, index: 0),
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
            game.table.objectives.first == nil
        )
        #expect(
            game.table.objectives.second == nil
        )
        #expect(
            game.table.objectives.third == nil
        )
        #expect(
            game.table.coinFlipLoserHand == [
                ChallengeCard(
                    challenge: .tieThemUp,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .spreadOut,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .getTheBall,
                    bonusPlay: .blitz
                ),
            ]
        )
        #expect(
            game.table.coinFlipWinnerHand == []
        )
        #expect(
            game.table.deck == []
        )
        #expect(
            game.table.discards == [
                ChallengeCard(
                    challenge: .takeThemDown,
                    bonusPlay: .blitz
                ),
                ChallengeCard(
                    challenge: .moveTheBall,
                    bonusPlay: .blitz
                ),
            ]
        )
    }
}
