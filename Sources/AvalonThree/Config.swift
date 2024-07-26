//
//  Config.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

/// "Coin flip winner" == "Second coach"
struct Config: Equatable, Codable {
    var rawTalentBonusRecipientID: CoachID?
    var coinFlipWinnerCoachID: CoachID?
    var coinFlipWinnerConfig: CoinFlipWinnerConfig?
    var coinFlipLoserConfig: CoinFlipLoserConfig?
}

public struct CoinFlipWinnerConfig: Equatable, Codable {
    let boardSpecID: BoardSpecID
    let challengeDeckID: ChallengeDeckID
    let teamID: TeamID
}

public struct CoinFlipLoserConfig: Equatable, Codable {
    let teamID: TeamID
}

struct FinalizedConfig: Equatable, Codable {
    let coinFlipWinnerCoachID: CoachID
    let coinFlipWinnerConfig: CoinFlipWinnerConfig
    let coinFlipLoserConfig: CoinFlipLoserConfig
}
