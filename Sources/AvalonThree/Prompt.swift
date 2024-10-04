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
        playerSquare: Square
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
        playerSquare: Square
    )

    case runActionEligibleForDodgeBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case runActionEligibleForSprintBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case runActionSpecifySquares(
        playerID: PlayerID,
        playerSquare: Square,
        maxRunDistance: Int,
        validSquares: ValidMoveSquares
    )

    // MARK: - Mark action

    case markActionEligibleForInterferenceBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case markActionSpecifySquares(
        playerID: PlayerID,
        playerSquare: Square,
        validSquares: ValidMoveSquares
    )

    // MARK: - Pass action

    case passActionEligibleForHailMaryPassBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case passActionSpecifyTarget(
        playerID: PlayerID,
        playerSquare: Square,
        validTargets: Set<PassTarget>
    )

    case passActionEligibleForAccuratePassBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case passActionEligibleForProBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case passActionResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        playerSquare: Square,
        result: Int
    )

    // MARK: - Hurl teammate action

    case hurlTeammateActionSpecifyTeammate(
        playerID: PlayerID,
        playerSquare: Square,
        validTeammates: [PlayerID: Square]
    )

    case hurlTeammateActionSpecifyTarget(
        playerID: PlayerID,
        playerSquare: Square,
        validTargets: Set<HurlTeammateTarget>
    )

    case hurlTeammateActionEligibleForAccuratePassBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case hurlTeammateActionEligibleForProBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        playerSquare: Square,
        result: Int
    )

    // MARK: - Foul action

    case foulActionSpecifyTarget(
        playerID: PlayerID,
        playerSquare: Square,
        validTargets: [PlayerID: Square]
    )

    // MARK: - Block action

    case blockActionSpecifyTarget(
        playerID: PlayerID,
        playerSquare: Square,
        validTargets: [PlayerID: Square]
    )

    case blockActionEligibleForStepAsideBonusPlaySidestepAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionEligibleForBodyCheckBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionEligibleForTheKidsGotMoxyBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
        playerID: PlayerID,
        playerSquare: Square,
        results: [BlockDieResult]
    )

    case blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        playerSquare: Square,
        results: [BlockDieResult],
        clawsResult: Int?,
        maySelectResultToDecline: Bool
    )

    case blockActionSelectResult(
        playerID: PlayerID,
        playerSquare: Square,
        results: [BlockDieResult]
    )

    case blockActionSelectSafeHandsLooseBallDirection(
        playerID: PlayerID,
        playerSquare: Square,
        directions: Set<Direction>
    )

    case blockActionEligibleForFollowUp(
        playerID: PlayerID,
        from: Square,
        to: Square
    )

    case blockActionEligibleForBladedKnuckleDustersBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionEligibleForAbsolutelyNailsBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionEligibleForToughEnoughBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionEligibleForProBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionEligibleForAbsoluteCarnageBonusPlay(
        playerID: PlayerID,
        playerSquare: Square
    )

    case blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
        playerID: PlayerID,
        playerSquare: Square,
        result: Int
    )

    // MARK: - Sidestep action

    case sidestepActionSpecifySquare(
        playerID: PlayerID,
        playerSquare: Square,
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
        playerSquare: Square
    )

    case eligibleForShoulderChargeBonusPlayBlockAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForDivingTackleBonusPlayBlockAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForHeadbuttSkillBlockAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForBlitzBonusPlayBlockAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForComboPlayBonusPlayFreeAction(
        validDeclaration: PromptValidDeclaration,
        playerSquare: Square
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
        objectives: [Int: Challenge]
    )

    case eligibleForReadyToGoBonusPlayRunAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForReadyToGoBonusPlaySidestepAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForReadyToGoBonusPlayStandUpAction(
        playerID: PlayerID,
        playerSquare: Square
    )

    case eligibleForYourTimeToShineBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForYourTimeToShineBonusPlayRunAction(
        validPlayers: [PlayerID: Square]
    )

    case eligibleForCatchersInstinctsSkillRunAction(
        playerID: PlayerID,
        playerSquare: Square
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
        objectives: [Int: Challenge]
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
