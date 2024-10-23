//
//  Game+ValidateInputMessage.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension Game {

    func validate(_ messageWrapper: InputMessageWrapper) throws {
        guard let previousAddressedPrompt else {
            guard messageWrapper.coachID == .home else {
                throw GameError("Message from wrong coach")
            }
            guard case .begin = messageWrapper.message else {
                throw GameError("Invalid message")
            }
            return
        }

        guard messageWrapper.coachID == previousAddressedPrompt.coachID else {
            throw GameError("Message from wrong coach")
        }

        let prompt = previousAddressedPrompt.prompt

        switch messageWrapper.message {
        case .begin:
            throw GameError("Invalid message")

        case .selectBoardSpec:
            guard case .selectBoardSpec = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .configureChallengeDeck:
            guard case .configureChallengeDeck = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .selectRookieBonusRecipient:
            guard case .selectRookieBonusRecipient = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .selectTeam:
            guard case .selectTeam = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .arrangePlayers:
            guard case .arrangePlayers = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .declarePlayerAction:
            guard case .declarePlayerAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .declareEmergencyReservesAction:
            guard case .declareEmergencyReservesAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useRegenerationSkillStandUpAction,
             .declineRegenerationSkillStandUpAction:
            guard case .eligibleForRegenerationSkillStandUpAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useJumpUpBonusPlayStandUpAction,
             .declineJumpUpBonusPlayStandUpAction:
            guard case .eligibleForJumpUpBonusPlayStandUpAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useReservesBonusPlayReservesAction,
             .declineReservesBonusPlayReservesAction:
            guard case .eligibleForReservesBonusPlayReservesAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .runActionUseBlockingPlayBonusPlay,
             .runActionDeclineBlockingPlayBonusPlay:
            guard case .runActionEligibleForBlockingPlayBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .runActionUseDodgeBonusPlay,
             .runActionDeclineDodgeBonusPlay:
            guard case .runActionEligibleForDodgeBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .runActionUseSprintBonusPlay,
             .runActionDeclineSprintBonusPlay:
            guard case .runActionEligibleForSprintBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .runActionSelectSquares:
            guard case .runActionSelectSquares = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .markActionUseInterferenceBonusPlay,
             .markActionDeclineInterferenceBonusPlay:
            guard case .markActionEligibleForInterferenceBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .markActionSelectSquares:
            guard case .markActionSelectSquares = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseHailMaryPassBonusPlay,
             .passActionDeclineHailMaryPassBonusPlay:
            guard case .passActionEligibleForHailMaryPassBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .passActionSelectTarget:
            guard case .passActionSelectTarget = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseAccuratePassBonusPlay,
             .passActionDeclineAccuratePassBonusPlay:
            guard case .passActionEligibleForAccuratePassBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseProBonusPlay,
             .passActionDeclineProBonusPlay:
            guard case .passActionEligibleForProBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .passActionUseRawTalentBonusPlayReroll,
             .passActionDeclineRawTalentBonusPlayReroll:
            guard case .passActionResultEligibleForRawTalentBonusPlayReroll = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionSelectTeammate:
            guard case .hurlTeammateActionSelectTeammate = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionSelectTarget:
            guard case .hurlTeammateActionSelectTarget = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionUseAccuratePassBonusPlay,
             .hurlTeammateActionDeclineAccuratePassBonusPlay:
            guard case .hurlTeammateActionEligibleForAccuratePassBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionUseProBonusPlay,
             .hurlTeammateActionDeclineProBonusPlay:
            guard case .hurlTeammateActionEligibleForProBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .hurlTeammateActionUseRawTalentBonusPlayReroll,
             .hurlTeammateActionDeclineRawTalentBonusPlayReroll:
            guard case .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .foulActionSelectTarget:
            guard case .foulActionSelectTarget = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionSelectTarget:
            guard case .blockActionSelectTarget = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseStepAsideBonusPlaySidestepAction,
             .blockActionDeclineStepAsideBonusPlaySidestepAction:
            guard case .blockActionEligibleForStepAsideBonusPlaySidestepAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseBodyCheckBonusPlay,
             .blockActionDeclineBodyCheckBonusPlay:
            guard case .blockActionEligibleForBodyCheckBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseTheKidsGotMoxyBonusPlay,
             .blockActionDeclineTheKidsGotMoxyBonusPlay:
            guard case .blockActionEligibleForTheKidsGotMoxyBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseOffensiveSpecialistSkillReroll,
             .blockActionDeclineOffensiveSpecialistSkillReroll:
            guard case .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseRawTalentBonusPlayRerollForBlockDieResults,
             .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults:
            guard case .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionSelectResult:
            guard case .blockActionSelectResult = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionSelectSafeHandsLooseBallDirection:
            guard case .blockActionSelectSafeHandsLooseBallDirection = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseFollowUp,
             .blockActionDeclineFollowUp:
            guard case .blockActionEligibleForFollowUp = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseBladedKnuckleDustersBonusPlay,
             .blockActionDeclineBladedKnuckleDustersBonusPlay:
            guard case .blockActionEligibleForBladedKnuckleDustersBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseAbsolutelyNailsBonusPlay,
             .blockActionDeclineAbsolutelyNailsBonusPlay:
            guard case .blockActionEligibleForAbsolutelyNailsBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseToughEnoughBonusPlay,
             .blockActionDeclineToughEnoughBonusPlay:
            guard case .blockActionEligibleForToughEnoughBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseProBonusPlay,
             .blockActionDeclineProBonusPlay:
            guard case .blockActionEligibleForProBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseAbsoluteCarnageBonusPlay,
             .blockActionDeclineAbsoluteCarnageBonusPlay:
            guard case .blockActionEligibleForAbsoluteCarnageBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .blockActionUseRawTalentBonusPlayRerollForArmourResult,
             .blockActionDeclineRawTalentBonusPlayRerollForArmourResult:
            guard case .blockActionArmourResultEligibleForRawTalentBonusPlayReroll = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .sidestepActionSelectSquare:
            guard case .sidestepActionSelectSquare = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .reservesActionSelectSquare:
            guard case .reservesActionSelectSquare = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useGetInThereBonusPlayReservesAction,
             .declineGetInThereBonusPlayReservesAction:
            guard case .eligibleForGetInThereBonusPlayReservesAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useFrenziedSkillBlockAction,
             .declineFrenziedSkillBlockAction:
            guard case .eligibleForFrenziedSkillBlockAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useShoulderChargeBonusPlayBlockAction,
             .declineShoulderChargeBonusPlayBlockAction:
            guard case .eligibleForShoulderChargeBonusPlayBlockAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useDivingTackleBonusPlayBlockAction,
             .declineDivingTackleBonusPlayBlockAction:
            guard case .eligibleForDivingTackleBonusPlayBlockAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useHeadbuttSkillBlockAction,
             .declineHeadbuttSkillBlockAction:
            guard case .eligibleForHeadbuttSkillBlockAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useBlitzBonusPlayBlockAction,
             .declineBlitzBonusPlayBlockAction:
            guard case .eligibleForBlitzBonusPlayBlockAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useComboPlayBonusPlayFreeAction,
             .declineComboPlayBonusPlayFreeAction:
            guard case .eligibleForComboPlayBonusPlayFreeAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useDistractionBonusPlaySidestepAction,
             .declineDistractionBonusPlaySidestepAction:
            guard case .eligibleForDistractionBonusPlaySidestepAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useInterventionBonusPlayMarkAction,
             .declineInterventionBonusPlayMarkAction:
            guard case .eligibleForInterventionBonusPlayMarkAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .claimObjective,
             .declineToClaimObjective:
            guard case .earnedObjective = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useReadyToGoBonusPlayRunAction,
             .declineReadyToGoBonusPlayRunAction:
            guard case .eligibleForReadyToGoBonusPlayRunAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useReadyToGoBonusPlaySidestepAction,
             .declineReadyToGoBonusPlaySidestepAction:
            guard case .eligibleForReadyToGoBonusPlaySidestepAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useReadyToGoBonusPlayStandUpAction,
             .declineReadyToGoBonusPlayStandUpAction:
            guard case .eligibleForReadyToGoBonusPlayStandUpAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useYourTimeToShineBonusPlayReservesAction,
             .declineYourTimeToShineBonusPlayReservesAction:
            guard case .eligibleForYourTimeToShineBonusPlayReservesAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useYourTimeToShineBonusPlayRunAction,
             .declineYourTimeToShineBonusPlayRunAction:
            guard case .eligibleForYourTimeToShineBonusPlayRunAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useCatchersInstinctsSkillRunAction,
             .declineCatchersInstinctsSkillRunAction:
            guard case .eligibleForCatchersInstinctsSkillRunAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useInspirationBonusPlayFreeAction,
             .declineInspirationBonusPlayFreeAction:
            guard case .eligibleForInspirationBonusPlayFreeAction = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useShadowBonusPlayExtraMove,
             .declineShadowBonusPlayExtraMove:
            guard case .eligibleForShadowBonusPlayExtraMove = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .selectCardsToDiscardFromHand:
            guard case .selectCardsToDiscardFromHand = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .useDefensivePlayBonusPlay,
             .declineDefensivePlayBonusPlay:
            guard case .eligibleForDefensivePlayBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .usePassingPlayBonusPlay,
             .declinePassingPlayBonusPlay:
            guard case .eligibleForPassingPlayBonusPlay = prompt else {
                throw GameError("Invalid message")
            }
            return

        case .selectObjectiveToDiscard:
            guard case .selectObjectiveToDiscard = prompt else {
                throw GameError("Invalid message")
            }
            return
        }
    }
}
