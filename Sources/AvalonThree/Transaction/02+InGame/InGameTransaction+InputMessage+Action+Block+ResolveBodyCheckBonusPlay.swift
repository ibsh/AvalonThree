//
//  InGameTransaction+InputMessage+Action+Block+ResolveBodyCheckBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .bodyCheck }

    mutating func blockActionUseBodyCheckBonusPlay() throws -> Prompt? {

        let coachID = try history.latestTurnContext().coachID

        try useBonusPlay(
            bonusPlay: bonusPlay,
            coachID: coachID
        )

        events.append(
            .rolledForBlock(coachID: coachID, results: [.kerrunch])
        )
        history.append(.blockResults([.kerrunch]))
        return try blockActionSelectResult(result: .kerrunch)
    }

    mutating func blockActionDeclineBodyCheckBonusPlay() throws -> Prompt? {
        return try blockActionPrepareToRollDice()
    }
}
