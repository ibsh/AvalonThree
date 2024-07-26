//
//  Game+ValidateInputMessage.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension Game {

    func validate(_ messageWrapper: InputMessageWrapper) throws {
        guard let previousPrompt else {
            guard messageWrapper.coachID == .home else {
                throw GameError("Message from wrong coach")
            }
            guard case .begin = messageWrapper.message else {
                throw GameError("Invalid message")
            }
            return
        }

        guard messageWrapper.coachID == previousPrompt.coachID else {
            throw GameError("Message from wrong coach")
        }

        let payload = previousPrompt.payload

        switch messageWrapper.message {
        case .begin:
            throw GameError("Invalid message")
        case .coinFlipWinnerConfig:
            guard case .coinFlipWinnerConfig = payload else {
                throw GameError("Invalid message")
            }
            return

        case .coinFlipLoserConfig:
            guard case .coinFlipLoserConfig = payload else {
                throw GameError("Invalid message")
            }
            return

        case .arrangePlayers:
            guard case .arrangePlayers = payload else {
                throw GameError("Invalid message")
            }
            return

        case .declarePlayerAction:
            guard case .declarePlayerAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .declareEmergencyReservesAction:
            guard case .declareEmergencyReservesAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useRegenerationSkillStandUpAction,
             .declineRegenerationSkillStandUpAction:
            guard case .eligibleForRegenerationSkillStandUpAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useJumpUpBonusPlayStandUpAction,
             .declineJumpUpBonusPlayStandUpAction:
            guard case .eligibleForJumpUpBonusPlayStandUpAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useReservesBonusPlayReservesAction,
             .declineReservesBonusPlayReservesAction:
            guard case .eligibleForReservesBonusPlayReservesAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .runActionUseBlockingPlayBonusPlay,
             .runActionDeclineBlockingPlayBonusPlay:
            guard case .runActionEligibleForBlockingPlayBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .runActionUseDodgeBonusPlay,
             .runActionDeclineDodgeBonusPlay:
            guard case .runActionEligibleForDodgeBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .runActionUseSprintBonusPlay,
             .runActionDeclineSprintBonusPlay:
            guard case .runActionEligibleForSprintBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .runActionSpecifySquares:
            guard case .runActionSpecifySquares = payload else {
                throw GameError("Invalid message")
            }
            return

        case .markActionUseInterferenceBonusPlay,
             .markActionDeclineInterferenceBonusPlay:
            guard case .markActionEligibleForInterferenceBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .markActionSpecifySquares:
            guard case .markActionSpecifySquares = payload else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseHailMaryPassBonusPlay,
             .passActionDeclineHailMaryPassBonusPlay:
            guard case .passActionEligibleForHailMaryPassBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .passActionSpecifyTarget:
            guard case .passActionSpecifyTarget = payload else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseAccuratePassBonusPlay,
             .passActionDeclineAccuratePassBonusPlay:
            guard case .passActionEligibleForAccuratePassBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseProBonusPlay,
             .passActionDeclineProBonusPlay:
            guard case .passActionEligibleForProBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseRawTalentBonusPlayReroll,
             .passActionDeclineRawTalentBonusPlayReroll:
            guard case .passActionResultEligibleForRawTalentBonusPlayReroll = payload else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionSpecifyTeammate:
            guard case .hurlTeammateActionSpecifyTeammate = payload else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionSpecifyTarget:
            guard case .hurlTeammateActionSpecifyTarget = payload else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionUseAccuratePassBonusPlay,
             .hurlTeammateActionDeclineAccuratePassBonusPlay:
            guard case .hurlTeammateActionEligibleForAccuratePassBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionUseProBonusPlay,
             .hurlTeammateActionDeclineProBonusPlay:
            guard case .hurlTeammateActionEligibleForProBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionUseRawTalentBonusPlayReroll,
             .hurlTeammateActionDeclineRawTalentBonusPlayReroll:
            guard case .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll = payload else {
                throw GameError("Invalid message")
            }
            return

        case .foulActionSpecifyTarget:
            guard case .foulActionSpecifyTarget = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionSpecifyTarget:
            guard case .blockActionSpecifyTarget = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseStepAsideBonusPlaySidestepAction,
             .blockActionDeclineStepAsideBonusPlaySidestepAction:
            guard case .blockActionEligibleForStepAsideBonusPlaySidestepAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseBodyCheckBonusPlay,
             .blockActionDeclineBodyCheckBonusPlay:
            guard case .blockActionEligibleForBodyCheckBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseTheKidsGotMoxyBonusPlay,
             .blockActionDeclineTheKidsGotMoxyBonusPlay:
            guard case .blockActionEligibleForTheKidsGotMoxyBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseOffensiveSpecialistSkillReroll,
             .blockActionDeclineOffensiveSpecialistSkillReroll:
            guard case .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseRawTalentBonusPlayRerollForBlockDieResults,
             .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults:
            guard case .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionSelectResult:
            guard case .blockActionSelectResult = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionSelectSafeHandsLooseBallDirection:
            guard case .blockActionSelectSafeHandsLooseBallDirection = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseFollowUp,
             .blockActionDeclineFollowUp:
            guard case .blockActionEligibleForFollowUp = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseBladedKnuckleDustersBonusPlay,
             .blockActionDeclineBladedKnuckleDustersBonusPlay:
            guard case .blockActionEligibleForBladedKnuckleDustersBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseAbsolutelyNailsBonusPlay,
             .blockActionDeclineAbsolutelyNailsBonusPlay:
            guard case .blockActionEligibleForAbsolutelyNailsBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseToughEnoughBonusPlay,
             .blockActionDeclineToughEnoughBonusPlay:
            guard case .blockActionEligibleForToughEnoughBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseProBonusPlay,
             .blockActionDeclineProBonusPlay:
            guard case .blockActionEligibleForProBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseAbsoluteCarnageBonusPlay,
             .blockActionDeclineAbsoluteCarnageBonusPlay:
            guard case .blockActionEligibleForAbsoluteCarnageBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseRawTalentBonusPlayRerollForArmourResult,
             .blockActionDeclineRawTalentBonusPlayRerollForArmourResult:
            guard case .blockActionArmourResultEligibleForRawTalentBonusPlayReroll = payload else {
                throw GameError("Invalid message")
            }
            return

        case .sidestepActionSpecifySquare:
            guard case .sidestepActionSpecifySquare = payload else {
                throw GameError("Invalid message")
            }
            return

        case .reservesActionSpecifySquare:
            guard case .reservesActionSpecifySquare = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useGetInThereBonusPlayReservesAction,
             .declineGetInThereBonusPlayReservesAction:
            guard case .eligibleForGetInThereBonusPlayReservesAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useFrenziedSkillBlockAction,
             .declineFrenziedSkillBlockAction:
            guard case .eligibleForFrenziedSkillBlockAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useShoulderChargeBonusPlayBlockAction,
             .declineShoulderChargeBonusPlayBlockAction:
            guard case .eligibleForShoulderChargeBonusPlayBlockAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useDivingTackleBonusPlayBlockAction,
             .declineDivingTackleBonusPlayBlockAction:
            guard case .eligibleForDivingTackleBonusPlayBlockAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useHeadbuttSkillBlockAction,
             .declineHeadbuttSkillBlockAction:
            guard case .eligibleForHeadbuttSkillBlockAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useBlitzBonusPlayBlockAction,
             .declineBlitzBonusPlayBlockAction:
            guard case .eligibleForBlitzBonusPlayBlockAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useComboPlayBonusPlayFreeAction,
             .declineComboPlayBonusPlayFreeAction:
            guard case .eligibleForComboPlayBonusPlayFreeAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useDistractionBonusPlaySidestepAction,
             .declineDistractionBonusPlaySidestepAction:
            guard case .eligibleForDistractionBonusPlaySidestepAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useInterventionBonusPlayMarkAction,
             .declineInterventionBonusPlayMarkAction:
            guard case .eligibleForInterventionBonusPlayMarkAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .claimObjective,
             .declineToClaimObjective:
            guard case .earnedObjective = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useReadyToGoBonusPlayRunAction,
             .declineReadyToGoBonusPlayRunAction:
            guard case .eligibleForReadyToGoBonusPlayRunAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useReadyToGoBonusPlaySidestepAction,
             .declineReadyToGoBonusPlaySidestepAction:
            guard case .eligibleForReadyToGoBonusPlaySidestepAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useReadyToGoBonusPlayStandUpAction,
             .declineReadyToGoBonusPlayStandUpAction:
            guard case .eligibleForReadyToGoBonusPlayStandUpAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useYourTimeToShineBonusPlayReservesAction,
             .declineYourTimeToShineBonusPlayReservesAction:
            guard case .eligibleForYourTimeToShineBonusPlayReservesAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useYourTimeToShineBonusPlayRunAction,
             .declineYourTimeToShineBonusPlayRunAction:
            guard case .eligibleForYourTimeToShineBonusPlayRunAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useCatchersInstinctsSkillRunAction,
             .declineCatchersInstinctsSkillRunAction:
            guard case .eligibleForCatchersInstinctsSkillRunAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useInspirationBonusPlayFreeAction,
             .declineInspirationBonusPlayFreeAction:
            guard case .eligibleForInspirationBonusPlayFreeAction = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useShadowBonusPlayExtraMove,
             .declineShadowBonusPlayExtraMove:
            guard case .eligibleForShadowBonusPlayExtraMove = payload else {
                throw GameError("Invalid message")
            }
            return

        case .selectCardsToDiscardFromHand:
            guard case .selectCardsToDiscardFromHand = payload else {
                throw GameError("Invalid message")
            }
            return

        case .useDefensivePlayBonusPlay,
             .declineDefensivePlayBonusPlay:
            guard case .eligibleForDefensivePlayBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .usePassingPlayBonusPlay,
             .declinePassingPlayBonusPlay:
            guard case .eligibleForPassingPlayBonusPlay = payload else {
                throw GameError("Invalid message")
            }
            return

        case .selectObjectiveToDiscard:
            guard case .selectObjectiveToDiscard = payload else {
                throw GameError("Invalid message")
            }
            return
        }
    }
}
