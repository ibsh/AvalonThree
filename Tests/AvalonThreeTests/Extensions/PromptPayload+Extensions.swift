//
//  File.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/29/24.
//

@testable import AvalonThree

extension PromptPayload {
    enum Case {
        case selectBoardSpec
        case selectChallengeDeck
        case selectRookieBonusRecipient
        case selectCoinFlipWinnerTeam
        case selectCoinFlipLoserTeam
        case arrangePlayers
        case declarePlayerAction
        case declareEmergencyReservesAction
        case eligibleForRegenerationSkillStandUpAction
        case eligibleForJumpUpBonusPlayStandUpAction
        case eligibleForReservesBonusPlayReservesAction
        case runActionEligibleForBlockingPlayBonusPlay
        case runActionEligibleForDodgeBonusPlay
        case runActionEligibleForSprintBonusPlay
        case runActionSelectSquares
        case markActionEligibleForInterferenceBonusPlay
        case markActionSelectSquares
        case passActionEligibleForHailMaryPassBonusPlay
        case passActionSelectTarget
        case passActionEligibleForAccuratePassBonusPlay
        case passActionEligibleForProBonusPlay
        case passActionResultEligibleForRawTalentBonusPlayReroll
        case hurlTeammateActionSelectTeammate
        case hurlTeammateActionSelectTarget
        case hurlTeammateActionEligibleForAccuratePassBonusPlay
        case hurlTeammateActionEligibleForProBonusPlay
        case hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll
        case foulActionSelectTarget
        case blockActionSelectTarget
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
        case sidestepActionSelectSquare
        case reservesActionSelectSquare
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
        case .selectBoardSpec: .selectBoardSpec
        case .selectChallengeDeck: .selectChallengeDeck
        case .selectRookieBonusRecipient: .selectRookieBonusRecipient
        case .selectCoinFlipWinnerTeam: .selectCoinFlipWinnerTeam
        case .selectCoinFlipLoserTeam: .selectCoinFlipLoserTeam
        case .arrangePlayers: .arrangePlayers
        case .declarePlayerAction: .declarePlayerAction
        case .declareEmergencyReservesAction: .declareEmergencyReservesAction
        case .eligibleForRegenerationSkillStandUpAction: .eligibleForRegenerationSkillStandUpAction
        case .eligibleForJumpUpBonusPlayStandUpAction: .eligibleForJumpUpBonusPlayStandUpAction
        case .eligibleForReservesBonusPlayReservesAction: .eligibleForReservesBonusPlayReservesAction
        case .runActionEligibleForBlockingPlayBonusPlay: .runActionEligibleForBlockingPlayBonusPlay
        case .runActionEligibleForDodgeBonusPlay: .runActionEligibleForDodgeBonusPlay
        case .runActionEligibleForSprintBonusPlay: .runActionEligibleForSprintBonusPlay
        case .runActionSelectSquares: .runActionSelectSquares
        case .markActionEligibleForInterferenceBonusPlay: .markActionEligibleForInterferenceBonusPlay
        case .markActionSelectSquares: .markActionSelectSquares
        case .passActionEligibleForHailMaryPassBonusPlay: .passActionEligibleForHailMaryPassBonusPlay
        case .passActionSelectTarget: .passActionSelectTarget
        case .passActionEligibleForAccuratePassBonusPlay: .passActionEligibleForAccuratePassBonusPlay
        case .passActionEligibleForProBonusPlay: .passActionEligibleForProBonusPlay
        case .passActionResultEligibleForRawTalentBonusPlayReroll: .passActionResultEligibleForRawTalentBonusPlayReroll
        case .hurlTeammateActionSelectTeammate: .hurlTeammateActionSelectTeammate
        case .hurlTeammateActionSelectTarget: .hurlTeammateActionSelectTarget
        case .hurlTeammateActionEligibleForAccuratePassBonusPlay: .hurlTeammateActionEligibleForAccuratePassBonusPlay
        case .hurlTeammateActionEligibleForProBonusPlay: .hurlTeammateActionEligibleForProBonusPlay
        case .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll: .hurlTeammateActionResultEligibleForRawTalentBonusPlayReroll
        case .foulActionSelectTarget: .foulActionSelectTarget
        case .blockActionSelectTarget: .blockActionSelectTarget
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
        case .sidestepActionSelectSquare: .sidestepActionSelectSquare
        case .reservesActionSelectSquare: .reservesActionSelectSquare
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
