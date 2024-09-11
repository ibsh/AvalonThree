//
//  Config.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

/// "Coin flip winner" == "Second coach"
struct Config: Equatable, Codable, Sendable {
    var coinFlipWinnerCoachID: CoachID?
    var coinFlipWinnerConfig: CoinFlipWinnerConfig?
    var coinFlipLoserConfig: CoinFlipLoserConfig?
}

public struct CoinFlipWinnerConfig: Equatable, Codable, Sendable {
    let boardSpecID: BoardSpecID
    let challengeDeckID: ChallengeDeckID
    let teamID: TeamID
    let rawTalentBonusRecipientID: CoachID?
}

public struct CoinFlipLoserConfig: Equatable, Codable, Sendable {
    let teamID: TeamID
}

struct FinalizedConfig: Equatable, Codable, Sendable {
    let coinFlipWinnerCoachID: CoachID
    let coinFlipWinnerConfig: CoinFlipWinnerConfig
    let coinFlipLoserConfig: CoinFlipLoserConfig
}
