//
//  Event.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

public enum Die: Equatable, Codable {
    case d6
    case d8
}

public enum Event: Equatable, Codable {

    case flippedCoin(CoachID)

    case coinFlipLoserConfigured(
        config: CoinFlipLoserConfig
    )

    case coinFlipWinnerConfigured(
        config: CoinFlipWinnerConfig
    )

    case tableWasSetUp(
        playerConfigs: Set<PlayerConfig>,
        deck: [ChallengeCard],
        coinFlipLoserHand: [ChallengeCard],
        coinFlipWinnerHand: [ChallengeCard]
    )

    case gameStarted

    case rolledForDirection(
        direction: Direction
    )

    case changedDirection(
        direction: Direction
    )

    case rolledForTrapdoor(
        trapdoorSquare: Square
    )

    case declaredAction(
        declaration: ActionDeclaration,
        isFree: Bool
    )

    case rolledForMaxRunDistance(
        maxRunDistance: Int
    )

    case rolledForPass(
        die: Die,
        unmodified: Int
    )

    case changedPassResult(
        die: Die,
        modified: Int,
        modifications: Set<PassRollModification>
    )

    case rolledForHurlTeammate(
        die: Die,
        unmodified: Int
    )

    case changedHurlTeammateResult(
        die: Die,
        modified: Int,
        modifications: Set<HurlTeammateRollModification>
    )

    case rolledForFoul(
        result: FoulDieResult
    )

    case rolledForClaws(
        result: Int
    )

    case rolledForBlock(
        results: [BlockDieResult]
    )

    case usedOffensiveSpecialistSkillReroll(
        playerID: PlayerID
    )

    case declinedOffensiveSpecialistSkillReroll(
        playerID: PlayerID
    )

    case changedBlockResults(
        results: [BlockDieResult],
        modifications: Set<BlockRollModification>
    )

    case selectedBlockDieResult(
        result: BlockDieResult
    )

    case declinedFollowUp(
        playerID: PlayerID
    )

    case selectedLooseBallDirection(
        direction: Direction
    )

    case rolledForArmour(
        die: Die,
        unmodified: Int
    )

    case changedArmourResult(
        die: Die,
        modified: Int,
        modifications: Set<ArmourRollModification>
    )

    case playerMoved(
        playerID: PlayerID,
        square: Square,
        reason: PlayerMoveReason
    )

    case playerCaughtBouncingBall(
        playerID: PlayerID,
        ballID: BallID
    )

    case playerPickedUpLooseBall(
        playerID: PlayerID,
        ballID: BallID
    )

    case playerPassedBall(
        playerID: PlayerID,
        square: Square
    )

    case playerFumbledBall(
        playerID: PlayerID
    )

    case playerCaughtPass(
        playerID: PlayerID
    )

    case playerFailedCatch(
        playerID: PlayerID
    )

    case playerHandedOffBall(
        playerID: PlayerID,
        square: Square
    )

    case playerCaughtHandoff(
        playerID: PlayerID
    )

    case playerHurledTeammate(
        playerID: PlayerID,
        teammateID: PlayerID,
        square: Square
    )

    case playerFumbledTeammate(
        playerID: PlayerID,
        teammateID: PlayerID
    )

    case hurledTeammateLanded(
        playerID: PlayerID
    )

    case hurledTeammateCrashed(
        playerID: PlayerID
    )

    case playerFouled(
        playerID: PlayerID,
        square: Square
    )

    case playerBlocked(
        playerID: PlayerID,
        square: Square
    )

    case playerThrewBomb(
        playerID: PlayerID,
        square: Square
    )

    case playerAssistedBlock(
        playerID: PlayerID,
        square: Square
    )

    case playerScoredTouchdown(
        playerID: PlayerID,
        ballID: BallID
    )

    case newBallAppeared(
        ballID: BallID,
        square: Square
    )

    case ballCameLoose(
        ballID: BallID
    )

    case ballDisappeared(
        ballID: BallID
    )

    case ballBounced(
        ballID: BallID,
        to: Square
    )

    case playerFellDown(
        playerID: PlayerID,
        reason: PlayerFallDownReason
    )

    case playerStoodUp(
        playerID: PlayerID
    )

    case playerInjured(
        playerID: PlayerID,
        reason: PlayerInjuryReason
    )

    case playerSentOff(
        playerID: PlayerID
    )

    case playerCannotTakeActions(
        playerID: PlayerID
    )

    case playerCanTakeActions(
        playerID: PlayerID
    )

    case declinedRegenerationSkillStandUpAction(
        playerID: PlayerID
    )

    case declinedFrenziedSkillBlockAction(
        playerID: PlayerID
    )

    case declinedHeadbuttSkillBlockAction(
        playerID: PlayerID
    )

    case claimedObjective(
        coachID: CoachID,
        objectiveID: ObjectiveID
    )

    case declinedObjectives(
        coachID: CoachID,
        objectiveIDs: [ObjectiveID]
    )

    case declinedCatchersInstinctsSkillRunAction(
        playerID: PlayerID
    )

    case earnedCleanSweep(
        coachID: CoachID
    )

    case dealtNewObjective(
        objectiveID: ObjectiveID
    )

    case discardedObjective(
        coachID: CoachID,
        objectiveID: ObjectiveID
    )

    case discardedCardsFromHand(
        coachID: CoachID,
        cards: [ChallengeCard]
    )

    case revealedInstantBonusPlay(
        coachID: CoachID,
        bonusPlay: BonusPlay
    )

    case revealedPersistentBonusPlay(
        coachID: CoachID,
        bonusPlay: BonusPlay
    )

    case discardedPersistentBonusPlay(
        coachID: CoachID,
        bonusPlay: BonusPlay
    )

    case scoreUpdated(
        coachID: CoachID,
        increment: Int
    )

    case turnEnded(
        coachID: CoachID
    )

    case finalTurnBegan

    case gameEnded(
        endConditions: EndConditions
    )
}

public enum PassRollModification: Hashable, Codable {
    case longDistance
    case obstructed
    case targetPlayerMarked
}

public enum HurlTeammateRollModification: Hashable, Codable {
    case longDistance
    case obstructed
}

public enum BlockRollModification: Hashable, Codable {
    case playerThrewBomb
    case playerIsHulkingBrute
    case playerHasMightyBlow
    case playerIsInsignificant
    case playerIsTitchy
    case opponentIsHulkingBrute
    case opponentHasStandFirm
}

public enum ArmourRollModification: Hashable, Codable {
    case kerrunch
    case absoluteCarnageBonusPlay
}

public enum PlayerMoveReason: Equatable, Codable {
    case run
    case reserves
    case sidestep
    case mark
    case shoved
    case followUp
    case shadow
}

public enum PlayerFallDownReason: Equatable, Codable {
    case blocked
    case divingTackle
}

public enum PlayerInjuryReason: Equatable, Codable {
    case blocked
    case fouled
    case fumbled
    case trapdoor
}

public enum EndConditions: Equatable, Codable {
    case suddenDeath(CoachID)
    case clock(CoachID)
    case tie
}
