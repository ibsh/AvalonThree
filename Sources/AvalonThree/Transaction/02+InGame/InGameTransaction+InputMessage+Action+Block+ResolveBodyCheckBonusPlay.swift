//
//  InGameTransaction+InputMessage+Action+Block+ResolveBodyCheckBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    private var bonusPlay: BonusPlay { .bodyCheck }

    mutating func blockActionUseBodyCheckBonusPlay() throws -> AddressedPrompt? {

        let coachID = try history.latestTurnContext().coachID

        _ = try useBonusPlay(
            bonusPlay: bonusPlay,
            coachID: coachID
        )

        let results = BlockResults(dice: [.kerrunch], claws: nil)

        events.append(
            .rolledForBlock(
                coachID: coachID,
                results: results
            )
        )
        history.append(.blockResults(results))
        return try blockActionSelectResult(dieIndex: 0)
    }

    mutating func blockActionDeclineBodyCheckBonusPlay() throws -> AddressedPrompt? {
        return try blockActionPrepareToRollDice()
    }
}
