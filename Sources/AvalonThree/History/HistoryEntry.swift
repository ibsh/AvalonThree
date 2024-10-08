//
//  HistoryEntry.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/6/24.
//

import Foundation

/// This is a bit like `Event` but it's all the stuff that we might need to check internally in
/// subsequent logic.
enum HistoryEntry: Equatable, Sendable {

    case prepareForTurn(
        coachID: CoachID,
        isSpecial: SpecialTurn?,
        mustDiscardObjective: Bool
    )

    case eligibleForDefensivePlayBonusPlay
    case eligibleForPassingPlayBonusPlay

    case choosingObjectiveToDiscard(objectiveIndices: [Int])
    case discardedObjective(objectiveIndex: Int)

    case declareEmergencyReservesAction
    case eligibleForRegenerationSkillStandUpAction(playerID: PlayerID)
    case eligibleForJumpUpBonusPlayStandUpAction
    case eligibleForReservesBonusPlayReservesAction

    case actionDeclaration(
        declaration: ActionDeclaration,
        snapshot: ActionSnapshot
    )
    case actionIsFree

    case runValidSquares(
        maxRunDistance: Int,
        validSquares: ValidMoveSquares
    )
    case runEligibleForBlockingPlayBonusPlay
    case runEligibleForDodgeBonusPlay
    case runEligibleForSprintBonusPlay

    case markValidSquares(
        maxMarkDistance: Int,
        validSquares: ValidMoveSquares
    )
    case markHasRequiredTargetPlayer(PlayerID)

    case passValidTargets(Set<PassTarget>)
    case passTarget(PassTarget)
    case passActionEligibleForProBonusPlay
    case passNegativeModifier
    case passRolled(
        effectivePassStat: Int,
        unmodifiedRoll: Int,
        modifiedRoll: Int
    )
    case passResultEligibleForRawTalentBonusPlayReroll
    case passSuccessful

    case hurlTeammateValidTeammates(Set<PlayerID>)
    case hurlTeammateTeammate(PlayerID)
    case hurlTeammateValidTargets(Set<HurlTeammateTarget>)
    case hurlTeammateTarget(HurlTeammateTarget)
    case hurlTeammateActionEligibleForProBonusPlay
    case hurlTeammateNegativeModifier
    case hurlTeammateRolled(
        effectivePassStat: Int,
        unmodifiedRoll: Int,
        modifiedRoll: Int
    )
    case hurlTeammateResultEligibleForRawTalentBonusPlayReroll
    case hurlTeammateSuccessful

    case foulValidTargets(Set<PlayerID>)

    case blockValidTargets(Set<PlayerID>)
    case blockIsDivingTackle
    case blockTarget(PlayerID)
    case blockAssisted
    case blockAssistingPlayer(PlayerID)
    case blockIsBomb
    case blockDiceCount(Int)
    case blockDieResultsEligibleForStepAsideBonusPlaySidestepAction
    case blockDieResultsEligibleForBodyCheckBonusPlay
    case blockDieResultsEligibleForTheKidsGotMoxyBonusPlay
    case blockResults([BlockDieResult])
    case blockResult(BlockDieResult)
    case blockDieResultsEligibleForOffensiveSpecialistSkillReroll
    case blockDieResultsEligibleForRawTalentBonusPlayReroll
    case blockAnimationEventsSent
    case blockSafeHandsDirections(Set<Direction>)
    case blockFollowUpSquare(Square)
    case blockTargetKnockedDown
    case eligibleForBladedKnuckleDustersBonusPlay
    case eligibleForAbsolutelyNailsBonusPlay
    case eligibleForToughEnoughBonusPlay
    case blockActionEligibleForProBonusPlay
    case eligibleForAbsoluteCarnageBonusPlay
    case armourResultEligibleForRawTalentBonusPlayReroll
    case blockTargetInjured

    case sidestepValidSquares(ValidMoveSquares)

    case reservesValidSquares(ValidMoveSquares)

    case playerInjured(PlayerID)

    case eligibleForGetInThereBonusPlayReservesAction(PlayerID)

    case actionFinished
    case actionCancelled

    case touchdown

    case eligibleForFrenziedSkillBlockAction(playerID: PlayerID)
    case eligibleForShoulderChargeBonusPlayBlockAction(playerID: PlayerID)
    case eligibleForDivingTackleBonusPlayBlockAction(playerID: PlayerID)
    case eligibleForHeadbuttSkillBlockAction(playerID: PlayerID)
    case eligibleForBlitzBonusPlayBlockAction(playerID: PlayerID)
    case eligibleForComboPlayBonusPlayFreeAction(
        validDeclaration: ValidDeclaration
    )
    case eligibleForDistractionBonusPlaySidestepAction(Set<PlayerID>)
    case eligibleForInterventionBonusPlayMarkAction(
        Set<ValidDeclaration>,
        target: PlayerID
    )

    case choosingObjectiveToClaim(objectiveIndices: [Int])
    case claimedObjective(objectiveIndex: Int)
    case declinedToClaimObjective

    case eligibleForReadyToGoBonusPlayFreeAction(PlayerID)
    case eligibleForYourTimeToShineBonusPlayReservesAction(Set<PlayerID>)
    case eligibleForYourTimeToShineBonusPlayRunAction(Set<PlayerID>)
    case eligibleForCatchersInstinctsSkillRunAction(playerID: PlayerID)
    case eligibleForInspirationBonusPlayFreeAction
    case eligibleForShadowBonusPlayExtraMove(
        validPlayers: Set<PlayerID>,
        square: Square
    )

    case usedBonusPlay(
        coachID: CoachID,
        bonusPlay: BonusPlay
    )

    case turnFinished
}

enum SpecialTurn: Equatable {
    case first
    case second
    case final
}
