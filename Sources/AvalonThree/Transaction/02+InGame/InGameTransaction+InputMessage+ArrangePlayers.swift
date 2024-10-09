//
//  InGameTransaction+InputMessage+ArrangePlayers.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func arrangePlayers(
        playerPositions: [Square]
    ) throws -> AddressedPrompt? {

        history.append(
            .prepareForTurn(
                coachID: table.coinFlipLoserCoachID,
                isSpecial: .first,
                mustDiscardObjective: false
            )
        )

        return try beginTurn()
    }
}
