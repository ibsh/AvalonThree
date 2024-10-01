//
//  File.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/29/24.
//

@testable import AvalonThree

extension PromptPayload {
    enum Case {
        case specifyBoardSpec
        case specifyChallengeDeck
        case specifyRookieBonusRecipient
        case specifyCoinFlipWinnerTeam
        case specifyCoinFlipLoserTeam
        case arrangePlayers
        case declarePlayerAction
        case declareEmergencyReservesAction
        case eligibleForRegenerationSkillStandUpAction
        case eligibleForJumpUpBonusPlayStandUpAction
        case eligibleForReservesBonusPlayReservesAction
        case runActionEligibleForBlockingPlayBonusPlay
        case runActionEligibleForDodgeBonusPlay
        case runActionEligibleForSprintBonusPlay
        case runActionSpecifySquares
        case markActionEligibleForInterferenceBonusPlay
        case markActionSpecifySquares
        case passActionEligibleForHailMaryPassBonusPlay
        case passActionSpecifyTarget
        case passActionEligibleForAccuratePassBonusPlay
        case passActionEligibleForProBonusPlay
        case passActionResultEligibleForRawTalentBonusPlayReroll
        case hurlTeammateActionSpecifyTeammate
        case hurlTeammateActionSpecifyTarget
        case hurlTeammateActionEligibleForAccuratePassBonusPlay
        case hurlTeammateActionEligibleForProBonusPlay
        case hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll
        case foulActionSpecifyTarget
        case blockActionSpecifyTarget
        case blockActionEligibleForStepAsideBonusPlaySidestepAction
        case blockActionEligibleForBodyCheckBonusPlay
        case blockActionEligibleForTheKidsGotMoxyBonusPlay
        case blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll
        case blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll
        case blockActionSelectResult
        case blockActionSelectSafeHandsLooseBallDirection
        case blockActionEligibleForFollowUp
        case blockActionEligibleForBladedKnuckleDustersBonusPlay
        case blockActionEligibleForAbsolutelyNailsBonusPlay
        case blockActionEligibleForToughEnoughBonusPlay
        case blockActionEligibleForProBonusPlay
        case blockActionEligibleForAbsoluteCarnageBonusPlay
        case blockActionArmourResultEligibleForRawTalentBonusPlayReroll
        case sidestepActionSpecifySquare
        case reservesActionSpecifySquare
        case eligibleForGetInThereBonusPlayReservesAction
        case eligibleForFrenziedSkillBlockAction
        case eligibleForShoulderChargeBonusPlayBlockAction
        case eligibleForDivingTackleBonusPlayBlockAction
        case eligibleForHeadbuttSkillBlockAction
        case eligibleForBlitzBonusPlayBlockAction
        case eligibleForComboPlayBonusPlayFreeAction
        case eligibleForDistractionBonusPlaySidestepAction
        case eligibleForInterventionBonusPlayMarkAction
        case earnedObjective
        case eligibleForReadyToGoBonusPlayRunAction
        case eligibleForReadyToGoBonusPlaySidestepAction
        case eligibleForReadyToGoBonusPlayStandUpAction
        case eligibleForYourTimeToShineBonusPlayReservesAction
        case eligibleForYourTimeToShineBonusPlayRunAction
        case eligibleForCatchersInstinctsSkillRunAction
        case eligibleForInspirationBonusPlayFreeAction
        case eligibleForShadowBonusPlayExtraMove
        case selectCardsToDiscardFromHand
        case eligibleForDefensivePlayBonusPlay
        case eligibleForPassingPlayBonusPlay
        case selectObjectiveToDiscard
    }

    var `case`: Case {
        switch self {
        case .specifyBoardSpec: .specifyBoardSpec
        case .specifyChallengeDeck: .specifyChallengeDeck
        case .specifyRookieBonusRecipient: .specifyRookieBonusRecipient
        case .specifyCoinFlipWinnerTeam: .specifyCoinFlipWinnerTeam
        case .specifyCoinFlipLoserTeam: .specifyCoinFlipLoserTeam
        case .arrangePlayers: .arrangePlayers
        case .declarePlayerAction: .declarePlayerAction
        case .declareEmergencyReservesAction: .declareEmergencyReservesAction
        case .eligibleForRegenerationSkillStandUpAction: .eligibleForRegenerationSkillStandUpAction
        case .eligibleForJumpUpBonusPlayStandUpAction: .eligibleForJumpUpBonusPlayStandUpAction
        case .eligibleForReservesBonusPlayReservesAction: .eligibleForReservesBonusPlayReservesAction
        case .runActionEligibleForBlockingPlayBonusPlay: .runActionEligibleForBlockingPlayBonusPlay
        case .runActionEligibleForDodgeBonusPlay: .runActionEligibleForDodgeBonusPlay
        case .runActionEligibleForSprintBonusPlay: .runActionEligibleForSprintBonusPlay
        case .runActionSpecifySquares: .runActionSpecifySquares
        case .markActionEligibleForInterferenceBonusPlay: .markActionEligibleForInterferenceBonusPlay
        case .markActionSpecifySquares: .markActionSpecifySquares
        case .passActionEligibleForHailMaryPassBonusPlay: .passActionEligibleForHailMaryPassBonusPlay
        case .passActionSpecifyTarget: .passActionSpecifyTarget
        case .passActionEligibleForAccuratePassBonusPlay: .passActionEligibleForAccuratePassBonusPlay
        case .passActionEligibleForProBonusPlay: .passActionEligibleForProBonusPlay
        case .passActionResultEligibleForRawTalentBonusPlayReroll: .passActionResultEligibleForRawTalentBonusPlayReroll
        case .hurlTeammateActionSpecifyTeammate: .hurlTeammateActionSpecifyTeammate
        case .hurlTeammateActionSpecifyTarget: .hurlTeammateActionSpecifyTarget
        case .hurlTeammateActionEligibleForAccuratePassBonusPlay: .hurlTeammateActionEligibleForAccuratePassBonusPlay
        case .hurlTeammateActionEligibleForProBonusPlay: .hurlTeammateActionEligibleForProBonusPlay
        case .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll: .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll
        case .foulActionSpecifyTarget: .foulActionSpecifyTarget
        case .blockActionSpecifyTarget: .blockActionSpecifyTarget
        case .blockActionEligibleForStepAsideBonusPlaySidestepAction: .blockActionEligibleForStepAsideBonusPlaySidestepAction
        case .blockActionEligibleForBodyCheckBonusPlay: .blockActionEligibleForBodyCheckBonusPlay
        case .blockActionEligibleForTheKidsGotMoxyBonusPlay: .blockActionEligibleForTheKidsGotMoxyBonusPlay
        case .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll
        case .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll
        case .blockActionSelectResult: .blockActionSelectResult
        case .blockActionSelectSafeHandsLooseBallDirection: .blockActionSelectSafeHandsLooseBallDirection
        case .blockActionEligibleForFollowUp: .blockActionEligibleForFollowUp
        case .blockActionEligibleForBladedKnuckleDustersBonusPlay: .blockActionEligibleForBladedKnuckleDustersBonusPlay
        case .blockActionEligibleForAbsolutelyNailsBonusPlay: .blockActionEligibleForAbsolutelyNailsBonusPlay
        case .blockActionEligibleForToughEnoughBonusPlay: .blockActionEligibleForToughEnoughBonusPlay
        case .blockActionEligibleForProBonusPlay: .blockActionEligibleForProBonusPlay
        case .blockActionEligibleForAbsoluteCarnageBonusPlay: .blockActionEligibleForAbsoluteCarnageBonusPlay
        case .blockActionArmourResultEligibleForRawTalentBonusPlayReroll: .blockActionArmourResultEligibleForRawTalentBonusPlayReroll
        case .sidestepActionSpecifySquare: .sidestepActionSpecifySquare
        case .reservesActionSpecifySquare: .reservesActionSpecifySquare
        case .eligibleForGetInThereBonusPlayReservesAction: .eligibleForGetInThereBonusPlayReservesAction
        case .eligibleForFrenziedSkillBlockAction: .eligibleForFrenziedSkillBlockAction
        case .eligibleForShoulderChargeBonusPlayBlockAction: .eligibleForShoulderChargeBonusPlayBlockAction
        case .eligibleForDivingTackleBonusPlayBlockAction: .eligibleForDivingTackleBonusPlayBlockAction
        case .eligibleForHeadbuttSkillBlockAction: .eligibleForHeadbuttSkillBlockAction
        case .eligibleForBlitzBonusPlayBlockAction: .eligibleForBlitzBonusPlayBlockAction
        case .eligibleForComboPlayBonusPlayFreeAction: .eligibleForComboPlayBonusPlayFreeAction
        case .eligibleForDistractionBonusPlaySidestepAction: .eligibleForDistractionBonusPlaySidestepAction
        case .eligibleForInterventionBonusPlayMarkAction: .eligibleForInterventionBonusPlayMarkAction
        case .earnedObjective: .earnedObjective
        case .eligibleForReadyToGoBonusPlayRunAction: .eligibleForReadyToGoBonusPlayRunAction
        case .eligibleForReadyToGoBonusPlaySidestepAction: .eligibleForReadyToGoBonusPlaySidestepAction
        case .eligibleForReadyToGoBonusPlayStandUpAction: .eligibleForReadyToGoBonusPlayStandUpAction
        case .eligibleForYourTimeToShineBonusPlayReservesAction: .eligibleForYourTimeToShineBonusPlayReservesAction
        case .eligibleForYourTimeToShineBonusPlayRunAction: .eligibleForYourTimeToShineBonusPlayRunAction
        case .eligibleForCatchersInstinctsSkillRunAction: .eligibleForCatchersInstinctsSkillRunAction
        case .eligibleForInspirationBonusPlayFreeAction: .eligibleForInspirationBonusPlayFreeAction
        case .eligibleForShadowBonusPlayExtraMove: .eligibleForShadowBonusPlayExtraMove
        case .selectCardsToDiscardFromHand: .selectCardsToDiscardFromHand
        case .eligibleForDefensivePlayBonusPlay: .eligibleForDefensivePlayBonusPlay
        case .eligibleForPassingPlayBonusPlay: .eligibleForPassingPlayBonusPlay
        case .selectObjectiveToDiscard: .selectObjectiveToDiscard
        }
    }
}
