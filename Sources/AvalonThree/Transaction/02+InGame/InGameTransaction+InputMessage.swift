//
//  InGameTransaction+InputMessage.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension InGameTransaction {

    mutating func processInputMessageWrapper(
        _ messageWrapper: InputMessageWrapper
    ) throws -> AddressedPrompt? {

        switch messageWrapper.message {
        case .arrangePlayers(let playerPositions):
            return try arrangePlayers(
                playerPositions: playerPositions
            )

        case .declarePlayerAction(let declaration, let consumesBonusPlays):
            return try declareAction(
                declaration: declaration,
                consumesBonusPlays: consumesBonusPlays,
                isFree: false
            )

        case .declareEmergencyReservesAction(let playerID):
            return try declareEmergencyReservesAction(
                playerID: playerID
            )

        case .useRegenerationSkillStandUpAction:
            return try useRegenerationSkillStandUpAction()

        case .declineRegenerationSkillStandUpAction:
            return try declineRegenerationSkillStandUpAction()

        case .useJumpUpBonusPlayStandUpAction(let playerID):
            return try useJumpUpBonusPlayStandUpAction(
                playerID: playerID
            )

        case .declineJumpUpBonusPlayStandUpAction:
            return try declineJumpUpBonusPlayStandUpAction()

        case .useReservesBonusPlayReservesAction(let playerID):
            return try useReservesBonusPlayReservesAction(
                playerID: playerID
            )

        case .declineReservesBonusPlayReservesAction:
            return try declineReservesBonusPlayReservesAction()

        case .runActionUseBlockingPlayBonusPlay:
            return try runActionUseBlockingPlayBonusPlay()

        case .runActionDeclineBlockingPlayBonusPlay:
            return try runActionDeclineBlockingPlayBonusPlay()

        case .runActionUseDodgeBonusPlay:
            return try runActionUseDodgeBonusPlay()

        case .runActionDeclineDodgeBonusPlay:
            return try runActionDeclineDodgeBonusPlay()

        case .runActionUseSprintBonusPlay:
            return try runActionUseSprintBonusPlay()

        case .runActionDeclineSprintBonusPlay:
            return try runActionDeclineSprintBonusPlay()

        case .runActionSelectSquares(let squares):
            return try runActionSelectSquares(
                squares: squares
            )

        case .markActionUseInterferenceBonusPlay:
            return try markActionUseInterferenceBonusPlay()

        case .markActionDeclineInterferenceBonusPlay:
            return try markActionDeclineInterferenceBonusPlay()

        case .markActionSelectSquares(let squares):
            return try markActionSelectSquares(
                squares: squares
            )

        case .passActionUseHailMaryPassBonusPlay:
            return try passActionUseHailMaryPassBonusPlay()

        case .passActionDeclineHailMaryPassBonusPlay:
            return try passActionDeclineHailMaryPassBonusPlay()

        case .passActionSelectTarget(let target):
            return try passActionSelectTarget(
                target: target
            )

        case .passActionUseAccuratePassBonusPlay:
            return try passActionUseAccuratePassBonusPlay()

        case .passActionDeclineAccuratePassBonusPlay:
            return try passActionDeclineAccuratePassBonusPlay()

        case .passActionUseProBonusPlay:
            return try passActionUseProBonusPlay()

        case .passActionDeclineProBonusPlay:
            return try passActionDeclineProBonusPlay()

        case .passActionUseRawTalentBonusPlayReroll:
            return try passActionUseRawTalentBonusPlayReroll()

        case .passActionDeclineRawTalentBonusPlayReroll:
            return try passActionDeclineRawTalentBonusPlayReroll()

        case .hurlTeammateActionSelectTeammate(let teammate):
            return try hurlTeammateActionSelectTeammate(
                teammate: teammate
            )

        case .hurlTeammateActionSelectTarget(let targetSquare):
            return try hurlTeammateActionSelectTarget(
                targetSquare: targetSquare
            )

        case .hurlTeammateActionUseAccuratePassBonusPlay:
            return try hurlTeammateActionUseAccuratePassBonusPlay()

        case .hurlTeammateActionDeclineAccuratePassBonusPlay:
            return try hurlTeammateActionDeclineAccuratePassBonusPlay()

        case .hurlTeammateActionUseProBonusPlay:
            return try hurlTeammateActionUseProBonusPlay()

        case .hurlTeammateActionDeclineProBonusPlay:
            return try hurlTeammateActionDeclineProBonusPlay()

        case .hurlTeammateActionUseRawTalentBonusPlayReroll:
            return try hurlTeammateActionUseRawTalentBonusPlayReroll()

        case .hurlTeammateActionDeclineRawTalentBonusPlayReroll:
            return try hurlTeammateActionDeclineRawTalentBonusPlayReroll()

        case .foulActionSelectTarget(let target):
            return try foulActionSelectTarget(
                target: target
            )

        case .blockActionSelectTarget(let target):
            return try blockActionSelectTarget(
                target: target
            )

        case .blockActionUseStepAsideBonusPlaySidestepAction:
            return try blockActionUseStepAsideBonusPlaySidestepAction()

        case .blockActionDeclineStepAsideBonusPlaySidestepAction:
            return try blockActionDeclineStepAsideBonusPlaySidestepAction()

        case .blockActionUseBodyCheckBonusPlay:
            return try blockActionUseBodyCheckBonusPlay()

        case .blockActionDeclineBodyCheckBonusPlay:
            return try blockActionDeclineBodyCheckBonusPlay()

        case .blockActionUseTheKidsGotMoxyBonusPlay:
            return try blockActionUseTheKidsGotMoxyBonusPlay()

        case .blockActionDeclineTheKidsGotMoxyBonusPlay:
            return try blockActionDeclineTheKidsGotMoxyBonusPlay()

        case .blockActionUseOffensiveSpecialistSkillReroll:
            return try blockActionUseOffensiveSpecialistSkillReroll()

        case .blockActionDeclineOffensiveSpecialistSkillReroll(let dieIndex):
            return try blockActionDeclineOffensiveSpecialistSkillReroll(
                dieIndex: dieIndex
            )

        case .blockActionUseRawTalentBonusPlayRerollForBlockDieResults:
            return try blockActionUseRawTalentBonusPlayRerollForBlockDieResults()

        case .blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(let dieIndex):
            return try blockActionDeclineRawTalentBonusPlayRerollForBlockDieResults(
                dieIndex: dieIndex
            )

        case .blockActionSelectResult(let dieIndex):
            return try blockActionSelectResult(
                dieIndex: dieIndex
            )

        case .blockActionSelectSafeHandsLooseBallDirection(let direction):
            return try blockActionSelectSafeHandsLooseBallDirection(
                direction: direction
            )

        case .blockActionUseFollowUp:
            return try blockActionUseFollowUp()

        case .blockActionDeclineFollowUp:
            return try blockActionDeclineFollowUp()

        case .blockActionUseBladedKnuckleDustersBonusPlay:
            return try blockActionUseBladedKnuckleDustersBonusPlay()

        case .blockActionDeclineBladedKnuckleDustersBonusPlay:
            return try blockActionDeclineBladedKnuckleDustersBonusPlay()

        case .blockActionUseAbsolutelyNailsBonusPlay:
            return try blockActionUseAbsolutelyNailsBonusPlay()

        case .blockActionDeclineAbsolutelyNailsBonusPlay:
            return try blockActionDeclineAbsolutelyNailsBonusPlay()

        case .blockActionUseToughEnoughBonusPlay:
            return try blockActionUseToughEnoughBonusPlay()

        case .blockActionDeclineToughEnoughBonusPlay:
            return try blockActionDeclineToughEnoughBonusPlay()

        case .blockActionUseProBonusPlay:
            return try blockActionUseProBonusPlay()

        case .blockActionDeclineProBonusPlay:
            return try blockActionDeclineProBonusPlay()

        case .blockActionUseAbsoluteCarnageBonusPlay:
            return try blockActionUseAbsoluteCarnageBonusPlay()

        case .blockActionDeclineAbsoluteCarnageBonusPlay:
            return try blockActionDeclineAbsoluteCarnageBonusPlay()

        case .blockActionUseRawTalentBonusPlayRerollForArmourResult:
            return try blockActionUseRawTalentBonusPlayRerollForArmourResult()

        case .blockActionDeclineRawTalentBonusPlayRerollForArmourResult:
            return try blockActionDeclineRawTalentBonusPlayRerollForArmourResult()

        case .sidestepActionSelectSquare(let square):
            return try sidestepActionSelectSquare(
                square: square
            )

        case .reservesActionSelectSquare(let square):
            return try reservesActionSelectSquare(
                square: square
            )

        case .useGetInThereBonusPlayReservesAction:
            return try useGetInThereBonusPlayReservesAction()

        case .declineGetInThereBonusPlayReservesAction:
            return try declineGetInThereBonusPlayReservesAction()

        case .useFrenziedSkillBlockAction:
            return try useFrenziedSkillBlockAction()

        case .declineFrenziedSkillBlockAction:
            return try declineFrenziedSkillBlockAction()

        case .useShoulderChargeBonusPlayBlockAction:
            return try useShoulderChargeBonusPlayBlockAction()

        case .declineShoulderChargeBonusPlayBlockAction:
            return try declineShoulderChargeBonusPlayBlockAction()

        case .useDivingTackleBonusPlayBlockAction:
            return try useDivingTackleBonusPlayBlockAction()

        case .declineDivingTackleBonusPlayBlockAction:
            return try declineDivingTackleBonusPlayBlockAction()

        case .useHeadbuttSkillBlockAction:
            return try useHeadbuttSkillBlockAction()

        case .declineHeadbuttSkillBlockAction:
            return try declineHeadbuttSkillBlockAction()

        case .useBlitzBonusPlayBlockAction:
            return try useBlitzBonusPlayBlockAction()

        case .declineBlitzBonusPlayBlockAction:
            return try declineBlitzBonusPlayBlockAction()

        case .useComboPlayBonusPlayFreeAction:
            return try useComboPlayBonusPlayFreeAction()

        case .declineComboPlayBonusPlayFreeAction:
            return try declineComboPlayBonusPlayFreeAction()

        case .useDistractionBonusPlaySidestepAction(let playerID):
            return try useDistractionBonusPlaySidestepAction(
                playerID: playerID
            )

        case .declineDistractionBonusPlaySidestepAction:
            return try declineDistractionBonusPlaySidestepAction()

        case .useInterventionBonusPlayMarkAction(let playerID):
            return try useInterventionBonusPlayMarkAction(
                playerID: playerID
            )

        case .declineInterventionBonusPlayMarkAction:
            return try declineInterventionBonusPlayMarkAction()

        case .claimObjective(let objectiveIndex):
            return try claimObjective(
                objectiveIndex: objectiveIndex
            )

        case .declineToClaimObjective:
            return try declineToClaimObjective()

        case .useReadyToGoBonusPlayRunAction:
            return try useReadyToGoBonusPlayRunAction()

        case .declineReadyToGoBonusPlayRunAction:
            return try declineReadyToGoBonusPlayRunAction()

        case .useReadyToGoBonusPlaySidestepAction:
            return try useReadyToGoBonusPlaySidestepAction()

        case .declineReadyToGoBonusPlaySidestepAction:
            return try declineReadyToGoBonusPlaySidestepAction()

        case .useReadyToGoBonusPlayStandUpAction:
            return try useReadyToGoBonusPlayStandUpAction()

        case .declineReadyToGoBonusPlayStandUpAction:
            return try declineReadyToGoBonusPlayStandUpAction()

        case .useYourTimeToShineBonusPlayReservesAction(let playerID):
            return try useYourTimeToShineBonusPlayReservesAction(
                playerID: playerID
            )

        case .declineYourTimeToShineBonusPlayReservesAction:
            return try declineYourTimeToShineBonusPlayReservesAction()

        case .useYourTimeToShineBonusPlayRunAction(let playerID):
            return try useYourTimeToShineBonusPlayRunAction(
                playerID: playerID
            )

        case .declineYourTimeToShineBonusPlayRunAction:
            return try declineYourTimeToShineBonusPlayRunAction()

        case .useCatchersInstinctsSkillRunAction:
            return try useCatchersInstinctsSkillRunAction()

        case .declineCatchersInstinctsSkillRunAction:
            return try declineCatchersInstinctsSkillRunAction()

        case .useInspirationBonusPlayFreeAction(let declaration, let consumesBonusPlays):
            return try useInspirationBonusPlayFreeAction(
                declaration: declaration,
                consumesBonusPlays: consumesBonusPlays
            )

        case .declineInspirationBonusPlayFreeAction:
            return try declineInspirationBonusPlayFreeAction()

        case .useShadowBonusPlayExtraMove(let playerID):
            return try useShadowBonusPlayExtraMove(
                playerID: playerID
            )

        case .declineShadowBonusPlayExtraMove:
            return try declineShadowBonusPlayExtraMove()

        case .selectCardsToDiscardFromHand(let cards):
            return try selectCardsToDiscardFromHand(
                cards: cards
            )

        case .useDefensivePlayBonusPlay:
            return try useDefensivePlayBonusPlay()

        case .declineDefensivePlayBonusPlay:
            return try declineDefensivePlayBonusPlay()

        case .usePassingPlayBonusPlay:
            return try usePassingPlayBonusPlay()

        case .declinePassingPlayBonusPlay:
            return try declinePassingPlayBonusPlay()

        case .selectObjectiveToDiscard(let objectiveIndex):
            return try selectObjectiveToDiscard(
                objectiveIndex: objectiveIndex
            )

        case .begin,
             .selectBoardSpec,
             .configureChallengeDeck,
             .selectRookieBonusRecipient,
             .selectTeam:
            throw GameError("Invalid message for InGameTransaction")
        }
    }
}
