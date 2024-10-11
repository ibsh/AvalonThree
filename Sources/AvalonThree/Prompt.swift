//
//  UIUpdate+Prompt.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

public struct AddressedPrompt: Equatable, Codable, Sendable {
    public let coachID: CoachID
    public let prompt: Prompt
}

public enum Prompt: Equatable, Codable, Sendable {

    // MARK: - Config

    case selectBoardSpec(
        boardSpecIDs: [BoardSpecID]
    )

    case selectChallengeDeck(
        challengeDeckIDs: [ChallengeDeckID]
    )

    case selectRookieBonusRecipient(
        rookieBonusRecipientIDs: [RookieBonusRecipientID]
    )

    case selectCoinFlipWinnerTeam(
        teamIDs: [TeamID]
    )

    case selectCoinFlipLoserTeam(
        teamIDs: [TeamID]
    )

    // MARK: - Table config

    case arrangePlayers(
        playerIDs: Set<PlayerID>,
        validSquares: Set<Square>
    )

    // MARK: - Turn

    case declarePlayerAction(
        validDeclarations: Set<PromptValidDeclaringPlayer>,
        playerActionsLeft: Int
    )

    case declareEmergencyReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForRegenerationSkillStandUpAction(
        player: PromptBoardPlayer
    )

    case eligibleForJumpUpBonusPlayStandUpAction(
        validPlayers: Set<PromptBoardPlayer>
    )

    case eligibleForReservesBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    // MARK: - Run action

    case runActionEligibleForBlockingPlayBonusPlay(
        player: PromptBoardPlayer
    )

    case runActionEligibleForDodgeBonusPlay(
        player: PromptBoardPlayer
    )

    case runActionEligibleForSprintBonusPlay(
        player: PromptBoardPlayer
    )

    case runActionSelectSquares(
        player: PromptBoardPlayer,
        maxDistance: Int,
        validSquares: ValidMoveSquares
    )

    // MARK: - Mark action

    case markActionEligibleForInterferenceBonusPlay(
        player: PromptBoardPlayer
    )

    case markActionSelectSquares(
        player: PromptBoardPlayer,
        maxDistance: Int,
        validSquares: ValidMoveSquares
    )

    // MARK: - Pass action

    case passActionEligibleForHailMaryPassBonusPlay(
        player: PromptBoardPlayer
    )

    case passActionSelectTarget(
        player: PromptBoardPlayer,
        validTargets: Set<PassTarget>
    )

    case passActionEligibleForAccuratePassBonusPlay(
        player: PromptBoardPlayer
    )

    case passActionEligibleForProBonusPlay(
        player: PromptBoardPlayer
    )

    case passActionResultEligibleForRawTalentBonusPlayReroll(
        player: PromptBoardPlayer,
        result: Int
    )

    // MARK: - Hurl teammate action

    case hurlTeammateActionSelectTeammate(
        player: PromptBoardPlayer,
        validTeammates: Set<PromptBoardPlayer>
    )

    case hurlTeammateActionSelectTarget(
        player: PromptBoardPlayer,
        validTargets: Set<HurlTeammateTarget>
    )

    case hurlTeammateActionEligibleForAccuratePassBonusPlay(
        player: PromptBoardPlayer
    )

    case hurlTeammateActionEligibleForProBonusPlay(
        player: PromptBoardPlayer
    )

    case hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll(
        player: PromptBoardPlayer,
        result: Int
    )

    // MARK: - Foul action

    case foulActionSelectTarget(
        player: PromptBoardPlayer,
        validTargets: Set<PromptBoardPlayer>
    )

    // MARK: - Block action

    case blockActionSelectTarget(
        player: PromptBoardPlayer,
        validTargets: Set<PromptBoardPlayer>
    )

    case blockActionEligibleForStepAsideBonusPlaySidestepAction(
        player: PromptBoardPlayer
    )

    case blockActionEligibleForBodyCheckBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionEligibleForTheKidsGotMoxyBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
        player: PromptBoardPlayer,
        results: [BlockDieResult],
        maySelectResultToDecline: Bool
    )

    case blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
        player: PromptBoardPlayer,
        results: [BlockDieResult],
        clawsResult: Int?,
        maySelectResultToDecline: Bool
    )

    case blockActionSelectResult(
        player: PromptBoardPlayer,
        results: [BlockDieResult]
    )

    case blockActionSelectSafeHandsLooseBallDirection(
        player: PromptBoardPlayer,
        directions: Set<PromptDirection>
    )

    case blockActionEligibleForFollowUp(
        player: PromptBoardPlayer,
        destination: Square
    )

    case blockActionEligibleForBladedKnuckleDustersBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionEligibleForAbsolutelyNailsBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionEligibleForToughEnoughBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionEligibleForProBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionEligibleForAbsoluteCarnageBonusPlay(
        player: PromptBoardPlayer
    )

    case blockActionArmourResultEligibleForRawTalentBonusPlayReroll(
        player: PromptBoardPlayer,
        result: Int
    )

    // MARK: - Sidestep action

    case sidestepActionSelectSquare(
        player: PromptBoardPlayer,
        validSquares: ValidMoveSquares
    )

    // MARK: - Stand up action

    // MARK: - Reserves action

    case reservesActionSelectSquare(
        playerID: PlayerID,
        validSquares: ValidMoveSquares
    )

    // MARK: - After injury

    case eligibleForGetInThereBonusPlayReservesAction(
        playerID: PlayerID
    )

    // MARK: - After action

    case eligibleForFrenziedSkillBlockAction(
        player: PromptBoardPlayer
    )

    case eligibleForShoulderChargeBonusPlayBlockAction(
        player: PromptBoardPlayer
    )

    case eligibleForDivingTackleBonusPlayBlockAction(
        player: PromptBoardPlayer
    )

    case eligibleForHeadbuttSkillBlockAction(
        player: PromptBoardPlayer
    )

    case eligibleForBlitzBonusPlayBlockAction(
        player: PromptBoardPlayer
    )

    case eligibleForComboPlayBonusPlayFreeAction(
        validDeclaration: PromptValidDeclaration,
        playerSquare: Square
    )

    case eligibleForDistractionBonusPlaySidestepAction(
        validPlayers: Set<PromptBoardPlayer>
    )

    case eligibleForInterventionBonusPlayMarkAction(
        /// Note that this is a set of declarations rather than player IDs because you might need to
        /// spend an Interference bonus play to make some of these declarations valid.
        validDeclarations: Set<PromptValidDeclaringPlayer>
    )

    case earnedObjective(
        objectives: [Int: Challenge]
    )

    case eligibleForReadyToGoBonusPlayRunAction(
        player: PromptBoardPlayer
    )

    case eligibleForReadyToGoBonusPlaySidestepAction(
        player: PromptBoardPlayer
    )

    case eligibleForReadyToGoBonusPlayStandUpAction(
        player: PromptBoardPlayer
    )

    case eligibleForYourTimeToShineBonusPlayReservesAction(
        validPlayers: Set<PlayerID>
    )

    case eligibleForYourTimeToShineBonusPlayRunAction(
        validPlayers: Set<PromptBoardPlayer>
    )

    case eligibleForCatchersInstinctsSkillRunAction(
        player: PromptBoardPlayer
    )

    case eligibleForInspirationBonusPlayFreeAction(
        validDeclarations: Set<PromptValidDeclaringPlayer>
    )

    case eligibleForShadowBonusPlayExtraMove(
        validPlayers: Set<PromptBoardPlayer>,
        square: Square
    )

    // MARK: - End turn

    case selectCardsToDiscardFromHand(
        hand: [ChallengeCard],
        active: [ChallengeCard],
        count: Int
    )

    // MARK: - Pre-turn

    case eligibleForDefensivePlayBonusPlay
    case eligibleForPassingPlayBonusPlay

    case selectObjectiveToDiscard(
        objectives: [Int: Challenge]
    )
}

public struct PromptDirection: Hashable, Codable, Sendable {
    public let direction: Direction
    public let destination: Square
}

public struct PromptBoardPlayer: Hashable, Codable, Sendable {
    public let id: PlayerID
    public let square: Square
}

public struct PromptValidDeclaringPlayer: Hashable, Codable, Sendable {
    public let playerID: PlayerID
    public let square: Square?
    public var declarations: [PromptValidDeclaration]
}

public struct PromptValidDeclaration: Hashable, Codable, Sendable {
    public let actionID: ActionID
    public let consumesBonusPlays: Set<BonusPlay>
}

public struct ValidMoveSquares: Hashable, Codable, Sendable {
    /// This is an overestimation for performance reasons. Do not use it for display to the player,
    /// only for path validation.
    public let intermediate: Set<Square>
    /// This is a precise set and can be displayed to the player if necessary.
    public let final: Set<Square>
}

public struct PassTarget: Hashable, Codable, Sendable {
    public let targetPlayer: PromptBoardPlayer
    public let distance: PassDistance
    public let obstructingSquares: Set<Square>
    public let markedTargetSquares: Set<Square>
}

public struct HurlTeammateTarget: Hashable, Codable, Sendable {
    public let targetSquare: Square
    public let distance: PassDistance
    public let obstructingSquares: Set<Square>
}
