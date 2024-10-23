//
//  File.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/29/24.
//

@testable import AvalonThree

extension Event {
    enum Case {
        case flippedCoin
        case specifiedBoardSpec
        case configuredChallengeDeck
        case specifiedRookieBonusRecipient
        case specifiedTeam
        case startingHandWasSetUp
        case playerReceivedNumber
        case startingPlayersWereSetUp
        case rolledForDirection
        case changedDirection
        case rolledForTrapdoor
        case declaredAction
        case rolledForMaxRunDistance
        case rolledForPass
        case changedPassResult
        case rolledForHurlTeammate
        case changedHurlTeammateResult
        case rolledForFoul
        case rolledForClaws
        case rolledForBlock
        case usedOffensiveSpecialistSkillReroll
        case declinedOffensiveSpecialistSkillReroll
        case changedBlockResults
        case selectedBlockDieResult
        case declinedFollowUp
        case selectedLooseBallDirection
        case rolledForArmour
        case changedArmourResult
        case playerMovedOutOfReserves
        case playerMoved
        case playerCaughtBouncingBall
        case playerPickedUpLooseBall
        case playerPassedBall
        case playerFumbledBall
        case playerCaughtPass
        case playerFailedCatch
        case playerHandedOffBall
        case playerCaughtHandoff
        case playerHurledTeammate
        case playerFumbledTeammate
        case hurledTeammateLanded
        case hurledTeammateCrashed
        case playerFouled
        case playerBlocked
        case playerThrewBomb
        case playerScoredTouchdown
        case newBallAppeared
        case ballCameLoose
        case ballDisappeared
        case ballBounced
        case playerFellDown
        case playerStoodUp
        case playerInjured
        case playerSentOff
        case playerCannotTakeActions
        case playerCanTakeActions
        case declinedRegenerationSkillStandUpAction
        case declinedFrenziedSkillBlockAction
        case declinedHeadbuttSkillBlockAction
        case claimedObjective
        case declinedObjectives
        case declinedCatchersInstinctsSkillRunAction
        case earnedCleanSweep
        case updatedDeck
        case updatedDiscards
        case dealtNewObjective
        case discardedObjective
        case discardedCardFromHand
        case activatedBonusPlay
        case discardedActiveBonusPlay
        case scoreUpdated
        case turnEnded
        case turnBegan
        case gameEnded
    }

    var `case`: Case {
        switch self {
        case .flippedCoin: .flippedCoin
        case .specifiedBoardSpec: .specifiedBoardSpec
        case .configuredChallengeDeck: .configuredChallengeDeck
        case .specifiedRookieBonusRecipient: .specifiedRookieBonusRecipient
        case .specifiedTeam: .specifiedTeam
        case .startingHandWasSetUp: .startingHandWasSetUp
        case .playerReceivedNumber: .playerReceivedNumber
        case .startingPlayersWereSetUp: .startingPlayersWereSetUp
        case .rolledForDirection: .rolledForDirection
        case .changedDirection: .changedDirection
        case .rolledForTrapdoor: .rolledForTrapdoor
        case .declaredAction: .declaredAction
        case .rolledForMaxRunDistance: .rolledForMaxRunDistance
        case .rolledForPass: .rolledForPass
        case .changedPassResult: .changedPassResult
        case .rolledForHurlTeammate: .rolledForHurlTeammate
        case .changedHurlTeammateResult: .changedHurlTeammateResult
        case .rolledForFoul: .rolledForFoul
        case .rolledForBlock: .rolledForBlock
        case .usedOffensiveSpecialistSkillReroll: .usedOffensiveSpecialistSkillReroll
        case .declinedOffensiveSpecialistSkillReroll: .declinedOffensiveSpecialistSkillReroll
        case .changedBlockResults: .changedBlockResults
        case .selectedBlockDieResult: .selectedBlockDieResult
        case .declinedFollowUp: .declinedFollowUp
        case .selectedLooseBallDirection: .selectedLooseBallDirection
        case .rolledForArmour: .rolledForArmour
        case .changedArmourResult: .changedArmourResult
        case .playerMovedOutOfReserves: .playerMovedOutOfReserves
        case .playerMoved: .playerMoved
        case .playerCaughtBouncingBall: .playerCaughtBouncingBall
        case .playerPickedUpLooseBall: .playerPickedUpLooseBall
        case .playerPassedBall: .playerPassedBall
        case .playerFumbledBall: .playerFumbledBall
        case .playerCaughtPass: .playerCaughtPass
        case .playerFailedCatch: .playerFailedCatch
        case .playerHandedOffBall: .playerHandedOffBall
        case .playerCaughtHandoff: .playerCaughtHandoff
        case .playerHurledTeammate: .playerHurledTeammate
        case .playerFumbledTeammate: .playerFumbledTeammate
        case .hurledTeammateLanded: .hurledTeammateLanded
        case .hurledTeammateCrashed: .hurledTeammateCrashed
        case .playerFouled: .playerFouled
        case .playerBlocked: .playerBlocked
        case .playerThrewBomb: .playerThrewBomb
        case .playerScoredTouchdown: .playerScoredTouchdown
        case .newBallAppeared: .newBallAppeared
        case .ballCameLoose: .ballCameLoose
        case .ballDisappeared: .ballDisappeared
        case .ballBounced: .ballBounced
        case .playerFellDown: .playerFellDown
        case .playerStoodUp: .playerStoodUp
        case .playerInjured: .playerInjured
        case .playerSentOff: .playerSentOff
        case .playerCannotTakeActions: .playerCannotTakeActions
        case .playerCanTakeActions: .playerCanTakeActions
        case .declinedRegenerationSkillStandUpAction: .declinedRegenerationSkillStandUpAction
        case .declinedFrenziedSkillBlockAction: .declinedFrenziedSkillBlockAction
        case .declinedHeadbuttSkillBlockAction: .declinedHeadbuttSkillBlockAction
        case .claimedObjective: .claimedObjective
        case .declinedObjectives: .declinedObjectives
        case .declinedCatchersInstinctsSkillRunAction: .declinedCatchersInstinctsSkillRunAction
        case .earnedCleanSweep: .earnedCleanSweep
        case .updatedDeck: .updatedDeck
        case .updatedDiscards: .updatedDiscards
        case .dealtNewObjective: .dealtNewObjective
        case .discardedObjective: .discardedObjective
        case .discardedCardFromHand: .discardedCardFromHand
        case .activatedBonusPlay: .activatedBonusPlay
        case .discardedActiveBonusPlay: .discardedActiveBonusPlay
        case .scoreUpdated: .scoreUpdated
        case .turnEnded: .turnEnded
        case .turnBegan: .turnBegan
        case .gameEnded: .gameEnded
        }
    }
}
