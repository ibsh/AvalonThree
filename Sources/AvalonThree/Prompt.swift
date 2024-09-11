//
//  UIUpdate+Prompt.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

public struct Prompt: Equatable, Codable, Sendable {
    public let coachID: CoachID
    public let payload: PromptPayload
}

public enum PromptPayload: Equatable, Codable, Sendable {

    // MARK: - Config

    case coinFlipWinnerConfig(
        boardSpecIDs: [BoardSpecID],
        challengeDeckIDs: [ChallengeDeckID],
        teamIDs: [TeamID]
    )

    case coinFlipLoserConfig(
        teamIDs: [TeamID]
    )

    // MARK: - Table config

    case arrangePlayers(
        playerConfigs: Set<PlayerConfig>
    )

    // MARK: - Turn

    case declarePlayerAction(
        validDeclarations: Set<ValidDeclaration>,
        playerActionsLeft: Int
    )

    case declareEmergencyReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForRegenerationSkillStandUpAction(
        playerID: PlayerID
    )

    case eligibleForJumpUpBonusPlayStandUpAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForReservesBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    // MARK: - Run action

    case runActionEligibleForBlockingPlayBonusPlay(
        playerID: PlayerID
    )

    case runActionEligibleForDodgeBonusPlay(
        playerID: PlayerID
    )

    case runActionEligibleForSprintBonusPlay(
        playerID: PlayerID
    )

    /// This is an exception to the principle that all prompts should have a closed series of
    /// options, since it's a massive list of squares and kind of pointless to compute in
    /// advance. Just let the client allow the user to specify their run square by square.
    case runActionSpecifySquares(
        playerID: PlayerID,
        maxRunDistance: Int,
        validSquares: ValidMoveSquares
    )

    // MARK: - Mark action

    case markActionEligibleForInterferenceBonusPlay(
        playerID: PlayerID
    )

    case markActionSpecifySquares(
        playerID: PlayerID,
        validSquares: ValidMoveSquares
    )

    // MARK: - Pass action

    case passActionEligibleForHailMaryPassBonusPlay(
        playerID: PlayerID
    )

    case passActionSpecifyTarget(
        playerID: PlayerID,
        validTargets: Set<PassTarget>
    )

    case passActionEligibleForAccuratePassBonusPlay(
        playerID: PlayerID
    )

    case passActionEligibleForProBonusPlay(
        playerID: PlayerID
    )

    case passActionResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        result: Int
    )

    // MARK: - Hurl teammate action

    case hurlTeammateActionSpecifyTeammate(
        playerID: PlayerID,
        validTeammates: Set<PlayerID>
    )

    case hurlTeammateActionSpecifyTarget(
        playerID: PlayerID,
        validTargets: Set<HurlTeammateTarget>
    )

    case hurlTeammateActionEligibleForAccuratePassBonusPlay(
        playerID: PlayerID
    )

    case hurlTeammateActionEligibleForProBonusPlay(
        playerID: PlayerID
    )

    case hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        result: Int
    )

    // MARK: - Foul action

    case foulActionSpecifyTarget(
        playerID: PlayerID,
        validTargets: Set<PlayerID>
    )

    // MARK: - Block action

    case blockActionSpecifyTarget(
        playerID: PlayerID,
        validTargets: Set<PlayerID>
    )

    case blockActionEligibleForStepAsideBonusPlaySidestepAction(
        playerID: PlayerID
    )

    case blockActionEligibleForBodyCheckBonusPlay(
        playerID: PlayerID
    )

    case blockActionEligibleForTheKidsGotMoxyBonusPlay(
        playerID: PlayerID
    )

    case blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
        playerID: PlayerID,
        results: [BlockDieResult]
    )

    case blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        results: [BlockDieResult],
        clawsResult: Int?,
        maySelectResultToDecline: Bool
    )

    case blockActionSelectResult(
        playerID: PlayerID,
        results: [BlockDieResult]
    )

    case blockActionSelectSafeHandsLooseBallDirection(
        playerID: PlayerID,
        directions: Set<Direction>
    )

    case blockActionEligibleForFollowUp(
        playerID: PlayerID,
        square: Square
    )

    case blockActionEligibleForBladedKnuckleDustersBonusPlay(
        playerID: PlayerID
    )

    case blockActionEligibleForAbsolutelyNailsBonusPlay(
        playerID: PlayerID
    )

    case blockActionEligibleForToughEnoughBonusPlay(
        playerID: PlayerID
    )

    case blockActionEligibleForProBonusPlay(
        playerID: PlayerID
    )

    case blockActionEligibleForAbsoluteCarnageBonusPlay(
        playerID: PlayerID
    )

    case blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        result: Int
    )

    // MARK: - Sidestep action

    case sidestepActionSpecifySquare(
        playerID: PlayerID,
        validSquares: ValidMoveSquares
    )

    // MARK: - Stand up action

    // MARK: - Reserves action

    case reservesActionSpecifySquare(
        playerID: PlayerID,
        validSquares: ValidMoveSquares
    )

    // MARK: - After injury

    case eligibleForGetInThereBonusPlayReservesAction(
        playerID: PlayerID
    )

    // MARK: - After action

    case eligibleForFrenziedSkillBlockAction(
        playerID: PlayerID
    )

    case eligibleForShoulderChargeBonusPlayBlockAction(
        playerID: PlayerID
    )

    case eligibleForDivingTackleBonusPlayBlockAction(
        playerID: PlayerID
    )

    case eligibleForHeadbuttSkillBlockAction(
        playerID: PlayerID
    )

    case eligibleForBlitzBonusPlayBlockAction(
        playerID: PlayerID
    )

    case eligibleForComboPlayBonusPlayFreeAction(
        validDeclaration: ValidDeclaration
    )

    case eligibleForDistractionBonusPlaySidestepAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForInterventionBonusPlayMarkAction(
        /// Note that this is a set of declarations rather than player IDs because you might need to
        /// spend an Interference bonus play to make some of these declarations valid.
        validDeclarations: Set<ValidDeclaration>
    )

    case earnedObjective(
        objectiveIDs: [ObjectiveID]
    )

    case eligibleForReadyToGoBonusPlayRunAction(
        playerID: PlayerID
    )

    case eligibleForReadyToGoBonusPlaySidestepAction(
        playerID: PlayerID
    )

    case eligibleForReadyToGoBonusPlayStandUpAction(
        playerID: PlayerID
    )

    case eligibleForYourTimeToShineBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForYourTimeToShineBonusPlayRunAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForCatchersInstinctsSkillRunAction(
        playerID: PlayerID
    )

    case eligibleForInspirationBonusPlayFreeAction(
        validDeclarations: Set<ValidDeclaration>
    )

    case eligibleForShadowBonusPlayExtraMove(
        validPlayers: Set<PlayerID>,
        square: Square
    )

    // MARK: - End turn

    case selectCardsToDiscardFromHand(
        cards: [ChallengeCard]
    )

    // MARK: - Pre-turn

    case eligibleForDefensivePlayBonusPlay
    case eligibleForPassingPlayBonusPlay

    case selectObjectiveToDiscard(
        objectiveIDs: [ObjectiveID]
    )
}

public struct ValidMoveSquares: Hashable, Codable, Sendable {
    /// This is an overestimation for performance reasons. Do not use it for display to the player,
    /// only for path validation.
    public let intermediate: Set<Square>
    /// This is a precise set and can be displayed to the player if necessary.
    public let final: Set<Square>
}

public struct PassTarget: Hashable, Codable, Sendable {
    public let targetPlayerID: PlayerID
    public let targetSquare: Square
    public let distance: PassDistance
    public let obstructingSquares: Set<Square>
    public let markedTargetSquares: Set<Square>
}

public struct HurlTeammateTarget: Hashable, Codable, Sendable {
    public let targetSquare: Square
    public let distance: PassDistance
    public let obstructingSquares: Set<Square>
}
