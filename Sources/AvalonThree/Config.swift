//
//  Config.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

/// Coin flip winner will ultimately take the second turn
struct Config: Equatable, Codable, Sendable {
    var coinFlipWinnerCoachID: CoachID?
    var boardSpecID: BoardSpecID?
    var challengeDeckConfig: ChallengeDeckConfig?
    var rookieBonusRecipientID: RookieBonusRecipientID?
    var coinFlipWinnerTeamID: TeamID?
    var coinFlipLoserTeamID: TeamID?
}

struct FinalizedConfig: Equatable, Codable, Sendable {
    let coinFlipWinnerCoachID: CoachID
    let boardSpecID: BoardSpecID
    let challengeDeckConfig: ChallengeDeckConfig
    let rookieBonusRecipientID: RookieBonusRecipientID
    let coinFlipWinnerTeamID: TeamID
    let coinFlipLoserTeamID: TeamID
}
