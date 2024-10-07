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

        case .selectBoardSpec(let boardSpecID):
            return try selectBoardSpec(
                boardSpecID: boardSpecID
            )

        case .selectChallengeDeck(let challengeDeckID):
            return try selectChallengeDeck(
                challengeDeckID: challengeDeckID
            )

        case .selectRookieBonusRecipient(let rookieBonusRecipientID):
            return try selectRookieBonusRecipient(
                rookieBonusRecipientID: rookieBonusRecipientID
            )

        case .selectCoinFlipWinnerTeam(let teamID):
            return try selectCoinFlipWinnerTeam(
                teamID: teamID
            )

        case .selectCoinFlipLoserTeam(let teamID):
            return try selectCoinFlipLoserTeam(
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
             .runActionSelectSquares,
             .markActionUseInterferenceBonusPlay,
             .markActionDeclineInterferenceBonusPlay,
             .markActionSelectSquares,
             .passActionUseHailMaryPassBonusPlay,
             .passActionDeclineHailMaryPassBonusPlay,
             .passActionSelectTarget,
             .passActionUseAccuratePassBonusPlay,
             .passActionDeclineAccuratePassBonusPlay,
             .passActionUseProBonusPlay,
             .passActionDeclineProBonusPlay,
             .passActionUseRawTalentBonusPlayReroll,
             .passActionDeclineRawTalentBonusPlayReroll,
             .hurlTeammateActionSelectTeammate,
             .hurlTeammateActionSelectTarget,
             .hurlTeammateActionUseAccuratePassBonusPlay,
             .hurlTeammateActionDeclineAccuratePassBonusPlay,
             .hurlTeammateActionUseProBonusPlay,
             .hurlTeammateActionDeclineProBonusPlay,
             .hurlTeammateActionUseRawTalentBonusPlayReroll,
             .hurlTeammateActionDeclineRawTalentBonusPlayReroll,
             .foulActionSelectTarget,
             .blockActionSelectTarget,
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
             .sidestepActionSelectSquare,
             .reservesActionSelectSquare,
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
