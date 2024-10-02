//
//  Event.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

public enum Event: Equatable, Codable, Sendable {

    case flippedCoin(
        coachID: CoachID
    )

    case specifiedBoardSpec(
        coachID: CoachID,
        boardSpecID: BoardSpecID,
        boardSpec: BoardSpec
    )

    case specifiedChallengeDeck(
        coachID: CoachID,
        challengeDeckID: ChallengeDeckID
    )

    case specifiedRookieBonusRecipient(
        coachID: CoachID,
        recipientCoachID: CoachID?
    )

    case specifiedTeam(
        coachID: CoachID,
        teamID: TeamID
    )

    case startingHandWasSetUp(
        coachID: CoachID,
        hand: [WrappedChallengeCard]
    )

    case playerReceivedNumber(
        playerID: PlayerID,
        number: Int
    )

    case startingPlayersWereSetUp(
        coachID: CoachID,
        playerSetups: [PlayerSetup]
    )

    case rolledForDirection(
        coachID: CoachID,
        direction: Direction
    )

    case changedDirection(
        from: Direction,
        to: Direction
    )

    case rolledForTrapdoor(
        coachID: CoachID,
        trapdoorSquare: Square
    )

    case declaredAction(
        declaration: ActionDeclaration,
        isFree: Bool,
        playerSquare: Square?
    )

    case rolledForMaxRunDistance(
        coachID: CoachID,
        maxRunDistance: Int
    )

    case rolledForPass(
        coachID: CoachID,
        die: Die,
        unmodified: Int
    )

    case changedPassResult(
        die: Die,
        unmodified: Int,
        modified: Int,
        modifications: [PassRollModification]
    )

    case rolledForHurlTeammate(
        coachID: CoachID,
        die: Die,
        unmodified: Int
    )

    case changedHurlTeammateResult(
        die: Die,
        unmodified: Int,
        modified: Int,
        modifications: [HurlTeammateRollModification]
    )

    case rolledForFoul(
        coachID: CoachID,
        result: FoulDieResult
    )

    case rolledForClaws(
        coachID: CoachID,
        result: Int
    )

    case rolledForBlock(
        coachID: CoachID,
        results: [BlockDieResult]
    )

    case usedOffensiveSpecialistSkillReroll(
        playerID: PlayerID,
        playerSquare: Square
    )

    case declinedOffensiveSpecialistSkillReroll(
        playerID: PlayerID,
        playerSquare: Square
    )

    case changedBlockResults(
        from: [BlockDieResult],
        to: [BlockDieResult],
        modifications: [BlockRollModification]
    )

    case selectedBlockDieResult(
        coachID: CoachID,
        result: BlockDieResult,
        from: [BlockDieResult]
    )

    case declinedFollowUp(
        playerID: PlayerID,
        playerSquare: Square
    )

    case selectedLooseBallDirection(
        playerID: PlayerID,
        playerSquare: Square,
        direction: Direction
    )

    case rolledForArmour(
        coachID: CoachID,
        die: Die,
        unmodified: Int
    )

    case changedArmourResult(
        die: Die,
        unmodified: Int,
        modified: Int,
        modifications: [ArmourRollModification]
    )

    case playerMovedOutOfReserves(
        playerID: PlayerID,
        to: Square
    )

    case playerMoved(
        playerID: PlayerID,
        ballID: Int?,
        from: Square,
        to: Square,
        direction: Direction,
        reason: PlayerMoveReason
    )

    case playerCaughtBouncingBall(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case playerPickedUpLooseBall(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case playerPassedBall(
        playerID: PlayerID,
        from: Square,
        to: Square,
        angle: Int,
        ballID: Int
    )

    case playerFumbledBall(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case playerCaughtPass(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case playerFailedCatch(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case playerHandedOffBall(
        playerID: PlayerID,
        from: Square,
        to: Square,
        direction: Direction,
        ballID: Int
    )

    case playerCaughtHandoff(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case playerHurledTeammate(
        playerID: PlayerID,
        teammateID: PlayerID,
        ballID: Int?,
        from: Square,
        to: Square,
        angle: Int
    )

    case playerFumbledTeammate(
        playerID: PlayerID,
        playerSquare: Square,
        teammateID: PlayerID,
        ballID: Int?
    )

    case hurledTeammateLanded(
        playerID: PlayerID,
        ballID: Int?,
        playerSquare: Square
    )

    case hurledTeammateCrashed(
        playerID: PlayerID,
        ballID: Int?,
        playerSquare: Square
    )

    case playerFouled(
        playerID: PlayerID,
        from: Square,
        to: Square,
        direction: Direction,
        targetPlayerID: PlayerID
    )

    case playerBlocked(
        playerID: PlayerID,
        from: Square,
        to: Square,
        direction: Direction,
        targetPlayerID: PlayerID
    )

    case playerThrewBomb(
        playerID: PlayerID,
        from: Square,
        to: Square,
        angle: Int
    )

    case playerAssistedBlock(
        assistingPlayerID: PlayerID,
        from: Square,
        to: Square,
        direction: Direction,
        targetPlayerID: PlayerID,
        blockingPlayerID: PlayerID
    )

    case playerScoredTouchdown(
        playerID: PlayerID,
        playerSquare: Square,
        ballID: Int
    )

    case newBallAppeared(
        ballID: Int,
        ballSquare: Square
    )

    case ballCameLoose(
        ballID: Int,
        ballSquare: Square
    )

    case ballDisappeared(
        ballID: Int,
        ballSquare: Square
    )

    case ballBounced(
        ballID: Int,
        from: Square,
        to: Square,
        direction: Direction
    )

    case playerFellDown(
        playerID: PlayerID,
        playerSquare: Square,
        reason: PlayerFallDownReason
    )

    case playerStoodUp(
        playerID: PlayerID,
        playerSquare: Square
    )

    case playerInjured(
        playerID: PlayerID,
        playerSquare: Square,
        reason: PlayerInjuryReason
    )

    case playerSentOff(
        playerID: PlayerID,
        playerSquare: Square
    )

    case playerCannotTakeActions(
        playerID: PlayerID,
        playerSquare: Square?
    )

    case playerCanTakeActions(
        playerID: PlayerID,
        playerSquare: Square?
    )

    case declinedRegenerationSkillStandUpAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case declinedFrenziedSkillBlockAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case declinedHeadbuttSkillBlockAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case claimedObjective(
        coachID: CoachID,
        objectiveID: ObjectiveID,
        objective: WrappedChallengeCard,
        hand: [WrappedChallengeCard]
    )

    case declinedObjectives(
        coachID: CoachID,
        objectives: [ObjectiveID: Challenge]
    )

    case declinedCatchersInstinctsSkillRunAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case earnedCleanSweep(
        coachID: CoachID
    )

    case updatedDeck(
        top: Challenge?,
        count: Int
    )

    case updatedDiscards(
        top: BonusPlay?,
        count: Int
    )

    case dealtNewObjective(
        coachID: CoachID,
        objectiveID: ObjectiveID,
        objective: Challenge
    )

    case discardedObjective(
        coachID: CoachID,
        objectiveID: ObjectiveID,
        objective: ChallengeCard
    )

    case discardedCardFromHand(
        coachID: CoachID,
        card: ChallengeCard,
        hand: [WrappedChallengeCard]
    )

    case activatedBonusPlay(
        coachID: CoachID,
        card: ChallengeCard,
        hand: [WrappedChallengeCard],
        active: [ChallengeCard]
    )

    case discardedActiveBonusPlay(
        coachID: CoachID,
        card: ChallengeCard,
        active: [ChallengeCard]
    )

    case scoreUpdated(
        coachID: CoachID,
        increment: Int,
        total: Int
    )

    case turnEnded(
        coachID: CoachID
    )

    case turnBegan(
        coachID: CoachID,
        isFinal: Bool
    )

    case gameEnded(
        endConditions: EndConditions
    )
}

public enum WrappedChallengeCard: Hashable, Codable, Sendable {
    case open(card: ChallengeCard)
    case closed(challenge: Challenge)
}

public struct PlayerSetup: Hashable, Codable, Sendable {
    public let id: PlayerID
    public let specID: PlayerSpecID
    public let spec: PlayerSpec
}

public enum ArmourRollModification: String, Hashable, Codable, Sendable {
    case kerrunch
    case absoluteCarnageBonusPlay
}

public enum BlockRollModification: String, Hashable, Codable, Sendable {
    case playerThrewBomb
    case playerIsHulkingBrute
    case playerHasMightyBlow
    case playerIsInsignificant
    case playerIsTitchy
    case opponentIsHulkingBrute
    case opponentHasStandFirm
}

public enum Die: String, Equatable, Codable, Sendable {
    case d6
    case d8
}

public enum EndConditions: Equatable, Codable, Sendable {
    case suddenDeath(CoachID)
    case clock(CoachID)
    case tie
}

public enum HurlTeammateRollModification: String, Hashable, Codable, Sendable {
    case longDistance
    case obstructed
}

public enum PassRollModification: String, Hashable, Codable, Sendable {
    case longDistance
    case obstructed
    case targetPlayerMarked
}

public enum PlayerFallDownReason: String, Equatable, Codable, Sendable {
    case blocked
    case divingTackle
}

public enum PlayerInjuryReason: String, Equatable, Codable, Sendable {
    case blocked
    case fouled
    case fumbled
    case trapdoor
}

public enum PlayerMoveReason: String, Equatable, Codable, Sendable {
    case run
    case sidestep
    case mark
    case shoved
    case followUp
    case shadow
}
