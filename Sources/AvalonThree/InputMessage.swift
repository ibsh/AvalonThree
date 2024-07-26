//
//  ClientMessage.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/5/24.
//

import Foundation

public enum InputMessage: Codable {

    // MARK: - Config

    case begin(rawTalentBonusRecipientID: CoachID?)
    case coinFlipWinnerConfig(config: CoinFlipWinnerConfig)
    case coinFlipLoserConfig(config: CoinFlipLoserConfig)

    // MARK: - Table config

    case arrangePlayers(playerPositions: [Square])

    // MARK: - Turn

    case declarePlayerAction(declaration: ActionDeclaration, consumesBonusPlays: [BonusPlay])
    case declareEmergencyReservesAction(playerID: PlayerID)
    case useRegenerationSkillStandUpAction
    case declineRegenerationSkillStandUpAction
    case useJumpUpBonusPlayStandUpAction(playerID: PlayerID)
    case declineJumpUpBonusPlayStandUpAction
    case useReservesBonusPlayReservesAction(playerID: PlayerID)
    case declineReservesBonusPlayReservesAction

    // MARK: - Run action

    case runActionUseBlockingPlayBonusPlay
    case runActionDeclineBlockingPlayBonusPlay
    case runActionUseDodgeBonusPlay
    case runActionDeclineDodgeBonusPlay
    case runActionUseSprintBonusPlay
    case runActionDeclineSprintBonusPlay
    case runActionSpecifySquares(squares: [Square])

    // MARK: - Mark action

    case markActionUseInterferenceBonusPlay
    case markActionDeclineInterferenceBonusPlay
    case markActionSpecifySquares(squares: [Square])

    // MARK: - Pass action

    case passActionUseHailMaryPassBonusPlay
    case passActionDeclineHailMaryPassBonusPlay
    case passActionSpecifyTarget(target: PlayerID)
    case passActionUseAccuratePassBonusPlay
    case passActionDeclineAccuratePassBonusPlay
    case passActionUseProBonusPlay
    case passActionDeclineProBonusPlay
    case passActionUseRawTalentBonusPlayReroll
    case passActionDeclineRawTalentBonusPlayReroll

    // MARK: - Hurl teammate action

    case hurlTeammateActionSpecifyTeammate(teammate: PlayerID)
    case hurlTeammateActionSpecifyTarget(targetSquare: Square)
    case hurlTeammateActionUseAccuratePassBonusPlay
    case hurlTeammateActionDeclineAccuratePassBonusPlay
    case hurlTeammateActionUseProBonusPlay
    case hurlTeammateActionDeclineProBonusPlay
    case hurlTeammateActionUseRawTalentBonusPlayReroll
    case hurlTeammateActionDeclineRawTalentBonusPlayReroll

    // MARK: - Foul action

    case foulActionSpecifyTarget(target: PlayerID)

    // MARK: - Block action

    case blockActionSpecifyTarget(target: PlayerID)
    case blockActionUseStepAsideBonusPlaySidestepAction
    case blockActionDeclineStepAsideBonusPlaySidestepAction
    case blockActionUseBodyCheckBonusPlay
    case blockActionDeclineBodyCheckBonusPlay
    case blockActionUseTheKidsGotMoxyBonusPlay
    case blockActionDeclineTheKidsGotMoxyBonusPlay
    case blockActionUseOffensiveSpecialistSkillReroll
    case blockActionDeclineOffensiveSpecialistSkillReroll(result: BlockDieResult)
    case blockActionUseRawTalentBonusPlayRerollForBlockDieResults
    case blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(result: BlockDieResult?)
    case blockActionSelectResult(result: BlockDieResult)
    case blockActionSelectSafeHandsLooseBallDirection(direction: Direction)
    case blockActionUseFollowUp
    case blockActionDeclineFollowUp
    case blockActionUseBladedKnuckleDustersBonusPlay
    case blockActionDeclineBladedKnuckleDustersBonusPlay
    case blockActionUseAbsolutelyNailsBonusPlay
    case blockActionDeclineAbsolutelyNailsBonusPlay
    case blockActionUseToughEnoughBonusPlay
    case blockActionDeclineToughEnoughBonusPlay
    case blockActionUseProBonusPlay
    case blockActionDeclineProBonusPlay
    case blockActionUseAbsoluteCarnageBonusPlay
    case blockActionDeclineAbsoluteCarnageBonusPlay
    case blockActionUseRawTalentBonusPlayRerollForArmourResult
    case blockActionDeclineRawTalentBonusPlayRerollForArmourResult

    // MARK: - Sidestep action

    case sidestepActionSpecifySquare(square: Square)

    // MARK: - Stand up action

    // MARK: - Reserves action

    case reservesActionSpecifySquare(square: Square)

    // MARK: - After injury

    case useGetInThereBonusPlayReservesAction
    case declineGetInThereBonusPlayReservesAction

    // MARK: - After action

    case useFrenziedSkillBlockAction
    case declineFrenziedSkillBlockAction

    case useShoulderChargeBonusPlayBlockAction
    case declineShoulderChargeBonusPlayBlockAction

    case useDivingTackleBonusPlayBlockAction
    case declineDivingTackleBonusPlayBlockAction

    case useHeadbuttSkillBlockAction
    case declineHeadbuttSkillBlockAction

    case useBlitzBonusPlayBlockAction
    case declineBlitzBonusPlayBlockAction

    case useComboPlayBonusPlayFreeAction
    case declineComboPlayBonusPlayFreeAction

    case useDistractionBonusPlaySidestepAction(playerID: PlayerID)
    case declineDistractionBonusPlaySidestepAction

    case useInterventionBonusPlayMarkAction(playerID: PlayerID)
    case declineInterventionBonusPlayMarkAction

    case claimObjective(objectiveID: ObjectiveID)
    case declineToClaimObjective

    case useReadyToGoBonusPlayRunAction
    case declineReadyToGoBonusPlayRunAction

    case useReadyToGoBonusPlaySidestepAction
    case declineReadyToGoBonusPlaySidestepAction

    case useReadyToGoBonusPlayStandUpAction
    case declineReadyToGoBonusPlayStandUpAction

    case useYourTimeToShineBonusPlayReservesAction(playerID: PlayerID)
    case declineYourTimeToShineBonusPlayReservesAction

    case useYourTimeToShineBonusPlayRunAction(playerID: PlayerID)
    case declineYourTimeToShineBonusPlayRunAction

    case useCatchersInstinctsSkillRunAction
    case declineCatchersInstinctsSkillRunAction

    case useInspirationBonusPlayFreeAction(declaration: ActionDeclaration)
    case declineInspirationBonusPlayFreeAction

    case useShadowBonusPlayExtraMove(playerID: PlayerID)
    case declineShadowBonusPlayExtraMove

    // MARK: - End turn

    case selectCardsToDiscardFromHand(cards: [ChallengeCard])

    // MARK: - Pre-turn

    case useDefensivePlayBonusPlay
    case declineDefensivePlayBonusPlay
    case usePassingPlayBonusPlay
    case declinePassingPlayBonusPlay
    case selectObjectiveToDiscard(objectiveID: ObjectiveID)
}

public struct InputMessageWrapper: Codable {
    let coachID: CoachID
    let message: InputMessage

    public init(
        coachID: CoachID,
        message: InputMessage
    ) {
        self.coachID = coachID
        self.message = message
    }
}
