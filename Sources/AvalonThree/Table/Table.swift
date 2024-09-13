//
//  Table.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

struct Table: Sendable {
    let config: FinalizedConfig

    var players: Set<Player>

    var coinFlipLoserHand: [ChallengeCard]
    var coinFlipWinnerHand: [ChallengeCard]

    var coinFlipLoserActiveBonuses: [ChallengeCard]
    var coinFlipWinnerActiveBonuses: [ChallengeCard]

    var coinFlipLoserScore: Int
    var coinFlipWinnerScore: Int

    var balls: Set<Ball>

    var deck: [ChallengeCard]
    var objectives: Objectives
    var discards: [ChallengeCard]
}

extension Table {

    var coinFlipLoserCoachID: CoachID {
        config.coinFlipWinnerCoachID.inverse
    }

    var coinFlipWinnerCoachID: CoachID {
        config.coinFlipWinnerCoachID
    }

    var coinFlipLoserTeamID: TeamID {
        config.coinFlipLoserTeamID
    }

    var coinFlipWinnerTeamID: TeamID {
        config.coinFlipWinnerTeamID
    }

    var boardSpecID: BoardSpecID {
        config.boardSpecID
    }
}
