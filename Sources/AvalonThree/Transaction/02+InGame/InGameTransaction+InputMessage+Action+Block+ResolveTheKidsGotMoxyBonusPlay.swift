//
//  InGameTransaction+InputMessage+Action+Block+ResolveTheKidsGotMoxyBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .theKidsGotMoxy }

    mutating func blockActionUseTheKidsGotMoxyBonusPlay() throws -> Prompt? {

        try useBonusPlay(
            bonusPlay: bonusPlay,
            coachID: try history.latestTurnContext().coachID
        )

        history.append(.blockDiceCount(3))

        return try blockActionPrepareToRollDice()
    }

    mutating func blockActionDeclineTheKidsGotMoxyBonusPlay() throws -> Prompt? {
        return try blockActionPrepareToRollDice()
    }
}
