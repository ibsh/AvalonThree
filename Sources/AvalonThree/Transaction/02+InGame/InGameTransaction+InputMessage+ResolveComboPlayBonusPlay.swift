//
//  InGameTransaction+InputMessage+ResolveComboPlayBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func useComboPlayBonusPlayFreeAction() throws -> Prompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last
        else {
            throw GameError("No action in history")
        }

        guard
            let validDeclaration = actionContext.history.lastResult(
                { entry -> ValidDeclaration? in
                    guard case .eligibleForComboPlayBonusPlayFreeAction(
                        let validDeclaration
                    ) = entry else {
                        return nil
                    }
                    return validDeclaration
                }
            )
        else {
            throw GameError("No valid declaration")
        }

        try useBonusPlay(bonusPlay: .comboPlay, coachID: actionContext.coachID)
        return try declareAction(
            declaration: validDeclaration.declaration,
            consumesBonusPlays: validDeclaration.consumesBonusPlays,
            isFree: true
        )
    }

    mutating func declineComboPlayBonusPlayFreeAction() throws -> Prompt? {
        return try endAction()
    }
}
