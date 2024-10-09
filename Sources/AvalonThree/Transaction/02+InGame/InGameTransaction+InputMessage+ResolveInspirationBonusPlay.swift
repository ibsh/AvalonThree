//
//  InGameTransaction+InputMessage+ResolveInspirationBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func useInspirationBonusPlayFreeAction(
        declaration: ActionDeclaration
    ) throws -> AddressedPrompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last
        else {
            throw GameError("No action in history")
        }

        _ = try useBonusPlay(bonusPlay: .inspiration, coachID: actionContext.coachID)
        return try declareAction(
            declaration: declaration,
            consumesBonusPlays: [],
            isFree: true
        )
    }

    mutating func declineInspirationBonusPlayFreeAction() throws -> AddressedPrompt? {
        return try endAction()
    }
}
