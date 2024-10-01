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

    case specifyBoardSpec(
        boardSpecIDs: [BoardSpecID]
    )

    case specifyChallengeDeck(
        challengeDeckIDs: [ChallengeDeckID]
    )

    case specifyRookieBonusRecipient(
        rookieBonusRecipientIDs: [RookieBonusRecipientID]
    )

    case specifyCoinFlipWinnerTeam(
        teamIDs: [TeamID]
    )

    case specifyCoinFlipLoserTeam(
        teamIDs: [TeamID]
    )

    // MARK: - Table config

    case arrangePlayers(
        playerIDs: Set<PlayerID>,
        validSquares: Set<Square>
    )

    // MARK: - Turn

    case declarePlayerAction(
        validDeclarations: [PlayerID: PromptValidDeclaringPlayer],
        playerActionsLeft: Int
    )

    case declareEmergencyReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForRegenerationSkillStandUpAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForJumpUpBonusPlayStandUpAction(
        validPlayers: [PlayerID: Square]
    )

    case eligibleForReservesBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    // MARK: - Run action

    case runActionEligibleForBlockingPlayBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case runActionEligibleForDodgeBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case runActionEligibleForSprintBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case runActionSpecifySquares(
        playerID: PlayerID,
        in: Square,
        maxRunDistance: Int,
        validSquares: ValidMoveSquares
    )

    // MARK: - Mark action

    case markActionEligibleForInterferenceBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case markActionSpecifySquares(
        playerID: PlayerID,
        in: Square,
        validSquares: ValidMoveSquares
    )

    // MARK: - Pass action

    case passActionEligibleForHailMaryPassBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case passActionSpecifyTarget(
        playerID: PlayerID,
        in: Square,
        validTargets: Set<PassTarget>
    )

    case passActionEligibleForAccuratePassBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case passActionEligibleForProBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case passActionResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        in: Square,
        result: Int
    )

    // MARK: - Hurl teammate action

    case hurlTeammateActionSpecifyTeammate(
        playerID: PlayerID,
        in: Square,
        validTeammates: [PlayerID: Square]
    )

    case hurlTeammateActionSpecifyTarget(
        playerID: PlayerID,
        in: Square,
        validTargets: Set<HurlTeammateTarget>
    )

    case hurlTeammateActionEligibleForAccuratePassBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case hurlTeammateActionEligibleForProBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        in: Square,
        result: Int
    )

    // MARK: - Foul action

    case foulActionSpecifyTarget(
        playerID: PlayerID,
        in: Square,
        validTargets: Set<PlayerID>
    )

    // MARK: - Block action

    case blockActionSpecifyTarget(
        playerID: PlayerID,
        in: Square,
        validTargets: Set<PlayerID>
    )

    case blockActionEligibleForStepAsideBonusPlaySidestepAction(
        playerID: PlayerID,
        in: Square
    )

    case blockActionEligibleForBodyCheckBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionEligibleForTheKidsGotMoxyBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
        playerID: PlayerID,
        in: Square,
        results: [BlockDieResult]
    )

    case blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        in: Square,
        results: [BlockDieResult],
        clawsResult: Int?,
        maySelectResultToDecline: Bool
    )

    case blockActionSelectResult(
        playerID: PlayerID,
        in: Square,
        results: [BlockDieResult]
    )

    case blockActionSelectSafeHandsLooseBallDirection(
        playerID: PlayerID,
        in: Square,
        directions: Set<Direction>
    )

    case blockActionEligibleForFollowUp(
        playerID: PlayerID,
        in: Square,
        square: Square
    )

    case blockActionEligibleForBladedKnuckleDustersBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionEligibleForAbsolutelyNailsBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionEligibleForToughEnoughBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionEligibleForProBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionEligibleForAbsoluteCarnageBonusPlay(
        playerID: PlayerID,
        in: Square
    )

    case blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        in: Square,
        result: Int
    )

    // MARK: - Sidestep action

    case sidestepActionSpecifySquare(
        playerID: PlayerID,
        in: Square,
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
        playerID: PlayerID,
        in: Square
    )

    case eligibleForShoulderChargeBonusPlayBlockAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForDivingTackleBonusPlayBlockAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForHeadbuttSkillBlockAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForBlitzBonusPlayBlockAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForComboPlayBonusPlayFreeAction(
        validDeclaration: PromptValidDeclaration,
        in: Square
    )

    case eligibleForDistractionBonusPlaySidestepAction(
        validPlayers: [PlayerID: Square]
    )

    case eligibleForInterventionBonusPlayMarkAction(
        /// Note that this is a set of declarations rather than player IDs because you might need to
        /// spend an Interference bonus play to make some of these declarations valid.
        validDeclarations: [PlayerID: PromptValidDeclaringPlayer]
    )

    case earnedObjective(
        objectives: [ObjectiveID: Challenge]
    )

    case eligibleForReadyToGoBonusPlayRunAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForReadyToGoBonusPlaySidestepAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForReadyToGoBonusPlayStandUpAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForYourTimeToShineBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForYourTimeToShineBonusPlayRunAction(
        validPlayers: [PlayerID: Square]
    )

    case eligibleForCatchersInstinctsSkillRunAction(
        playerID: PlayerID,
        in: Square
    )

    case eligibleForInspirationBonusPlayFreeAction(
        validDeclarations: [PlayerID: PromptValidDeclaringPlayer]
    )

    case eligibleForShadowBonusPlayExtraMove(
        validPlayers: [PlayerID: Square],
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
        objectives: [ObjectiveID: Challenge]
    )
}

public struct PromptValidDeclaringPlayer: Hashable, Codable, Sendable {
    let declarations: [PromptValidDeclaration]
    let square: Square?
}

public struct PromptValidDeclaration: Hashable, Codable, Sendable {
    public let actionID: ActionID
    public let consumesBonusPlays: [BonusPlay]
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
