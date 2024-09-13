//
//  ConfigTransaction+InputMessage.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/7/24.
//

import Foundation

extension ConfigTransaction {

    mutating func processInputMessageWrapper(
        _ messageWrapper: InputMessageWrapper
    ) throws -> Prompt? {

        switch messageWrapper.message {
        case .begin:
            return try beginGame()

        case .specifyBoardSpec(let boardSpecID):
            return try specifyBoardSpec(
                boardSpecID: boardSpecID
            )

        case .specifyChallengeDeck(let challengeDeckID):
            return try specifyChallengeDeck(
                challengeDeckID: challengeDeckID
            )

        case .specifyRookieBonusRecipient(let rookieBonusRecipientID):
            return try specifyRookieBonusRecipient(
                rookieBonusRecipientID: rookieBonusRecipientID
            )

        case .specifyCoinFlipWinnerTeam(let teamID):
            return try specifyCoinFlipWinnerTeam(
                teamID: teamID
            )

        case .specifyCoinFlipLoserTeam(let teamID):
            return try specifyCoinFlipLoserTeam(
                teamID: teamID
            )

        case .arrangePlayers,
             .declarePlayerAction,
             .declareEmergencyReservesAction,
             .useRegenerationSkillStandUpAction,
             .declineRegenerationSkillStandUpAction,
             .useJumpUpBonusPlayStandUpAction,
             .declineJumpUpBonusPlayStandUpAction,
             .useReservesBonusPlayReservesAction,
             .declineReservesBonusPlayReservesAction,
             .runActionUseBlockingPlayBonusPlay,
             .runActionDeclineBlockingPlayBonusPlay,
             .runActionUseDodgeBonusPlay,
             .runActionDeclineDodgeBonusPlay,
             .runActionUseSprintBonusPlay,
             .runActionDeclineSprintBonusPlay,
             .runActionSpecifySquares,
             .markActionUseInterferenceBonusPlay,
             .markActionDeclineInterferenceBonusPlay,
             .markActionSpecifySquares,
             .passActionUseHailMaryPassBonusPlay,
             .passActionDeclineHailMaryPassBonusPlay,
             .passActionSpecifyTarget,
             .passActionUseAccuratePassBonusPlay,
             .passActionDeclineAccuratePassBonusPlay,
             .passActionUseProBonusPlay,
             .passActionDeclineProBonusPlay,
             .passActionUseRawTalentBonusPlayReroll,
             .passActionDeclineRawTalentBonusPlayReroll,
             .hurlTeammateActionSpecifyTeammate,
             .hurlTeammateActionSpecifyTarget,
             .hurlTeammateActionUseAccuratePassBonusPlay,
             .hurlTeammateActionDeclineAccuratePassBonusPlay,
             .hurlTeammateActionUseProBonusPlay,
             .hurlTeammateActionDeclineProBonusPlay,
             .hurlTeammateActionUseRawTalentBonusPlayReroll,
             .hurlTeammateActionDeclineRawTalentBonusPlayReroll,
             .foulActionSpecifyTarget,
             .blockActionSpecifyTarget,
             .blockActionUseStepAsideBonusPlaySidestepAction,
             .blockActionDeclineStepAsideBonusPlaySidestepAction,
             .blockActionUseBodyCheckBonusPlay,
             .blockActionDeclineBodyCheckBonusPlay,
             .blockActionUseTheKidsGotMoxyBonusPlay,
             .blockActionDeclineTheKidsGotMoxyBonusPlay,
             .blockActionUseOffensiveSpecialistSkillReroll,
             .blockActionDeclineOffensiveSpecialistSkillReroll,
             .blockActionUseRawTalentBonusPlayRerollForBlockDieResults,
             .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults,
             .blockActionSelectResult,
             .blockActionSelectSafeHandsLooseBallDirection,
             .blockActionUseFollowUp,
             .blockActionDeclineFollowUp,
             .blockActionUseBladedKnuckleDustersBonusPlay,
             .blockActionDeclineBladedKnuckleDustersBonusPlay,
             .blockActionUseAbsolutelyNailsBonusPlay,
             .blockActionDeclineAbsolutelyNailsBonusPlay,
             .blockActionUseToughEnoughBonusPlay,
             .blockActionDeclineToughEnoughBonusPlay,
             .blockActionUseProBonusPlay,
             .blockActionDeclineProBonusPlay,
             .blockActionUseAbsoluteCarnageBonusPlay,
             .blockActionDeclineAbsoluteCarnageBonusPlay,
             .blockActionUseRawTalentBonusPlayRerollForArmourResult,
             .blockActionDeclineRawTalentBonusPlayRerollForArmourResult,
             .sidestepActionSpecifySquare,
             .reservesActionSpecifySquare,
             .useGetInThereBonusPlayReservesAction,
             .declineGetInThereBonusPlayReservesAction,
             .useFrenziedSkillBlockAction,
             .declineFrenziedSkillBlockAction,
             .useShoulderChargeBonusPlayBlockAction,
             .declineShoulderChargeBonusPlayBlockAction,
             .useDivingTackleBonusPlayBlockAction,
             .declineDivingTackleBonusPlayBlockAction,
             .useHeadbuttSkillBlockAction,
             .declineHeadbuttSkillBlockAction,
             .useBlitzBonusPlayBlockAction,
             .declineBlitzBonusPlayBlockAction,
             .useComboPlayBonusPlayFreeAction,
             .declineComboPlayBonusPlayFreeAction,
             .useDistractionBonusPlaySidestepAction,
             .declineDistractionBonusPlaySidestepAction,
             .useInterventionBonusPlayMarkAction,
             .declineInterventionBonusPlayMarkAction,
             .claimObjective,
             .declineToClaimObjective,
             .useReadyToGoBonusPlayRunAction,
             .declineReadyToGoBonusPlayRunAction,
             .useReadyToGoBonusPlaySidestepAction,
             .declineReadyToGoBonusPlaySidestepAction,
             .useReadyToGoBonusPlayStandUpAction,
             .declineReadyToGoBonusPlayStandUpAction,
             .useYourTimeToShineBonusPlayReservesAction,
             .declineYourTimeToShineBonusPlayReservesAction,
             .useYourTimeToShineBonusPlayRunAction,
             .declineYourTimeToShineBonusPlayRunAction,
             .useCatchersInstinctsSkillRunAction,
             .declineCatchersInstinctsSkillRunAction,
             .useInspirationBonusPlayFreeAction,
             .declineInspirationBonusPlayFreeAction,
             .useShadowBonusPlayExtraMove,
             .declineShadowBonusPlayExtraMove,
             .selectCardsToDiscardFromHand,
             .useDefensivePlayBonusPlay,
             .declineDefensivePlayBonusPlay,
             .usePassingPlayBonusPlay,
             .declinePassingPlayBonusPlay,
             .selectObjectiveToDiscard:
            throw GameError("Invalid message for ConfigTransaction")
        }
    }
}
