//
//  Table+Constants.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/29/24.
//

import Foundation

enum TableConstants {
    static let maxMarkDistance = 2
    static let maxSidestepDistance = 1
    static let maxBombDistance = 3
    static let clawsEffectiveD6Roll = 6
    static let maxPlayerActionsPerTurn = 3
    static let touchdownScoreValue = 4
    static let cleanSweepScoreValue = 2
    static let maxHandCount = 3
    static let suddenDeathDelta = 10

    static let getMovingRunCount = 3
    static let getTogetherTeammateCount = 2
    static let moveTheBallTargetDeltaY = 4
    static let tieThemUpMarkedTeammatesCount = 2
    static let tieThemUpMarkedOpponentsCount = 3
    static let goDeepPlayerCount = 2
    static let goDeepTargetDeltaY = 3
    static let lastChanceScoreDelta = 4
    static let pileOnOpponentsInReserveCount = 2
    static let playAsATeamCount = 3
    static let showSomeGritScoreDelta = 4
    static let showThemHowItsDoneCount = 3

    static let accuratePassBonusPlayPassStat = 2
    static let interferenceBonusPlayMaxMarkDistance = 4
    static let sprintBonusPlayMaxRunDistanceDelta = 2
    static let absoluteCarnageBonusPlayArmourDelta = 2
    static let absolutelyNailsBonusPlayArmourSuccess = 2
    static let hailMaryPassBonusPlayPassSuccess = 4
    static let legUpBonusPlayScoreValue = 1
    static let readyToGoBonusPlayMaxRunDistance = 1
    static let yourTimeToShineBonusPlayFreeReservesActionCount = 2
    static let yourTimeToShineBonusPlayFreeRunActionCount = 1

    static let d6Range = 1...6
    static let d8Range = 1...8

    static let rollOfOne = 1
    static let rollOfSix = 6
}
