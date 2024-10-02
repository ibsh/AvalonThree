//
//  InGameTransaction+InputMessage+ResolveInterventionBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/8/24.
//

import Foundation

extension InGameTransaction {

    mutating func useInterventionBonusPlayMarkAction(
        playerID: PlayerID
    ) throws -> Prompt? {
        return try resolveInterventionBonusPlayMarkAction(
            use: playerID
        )
    }

    mutating func declineInterventionBonusPlayMarkAction() throws -> Prompt? {
        return try resolveInterventionBonusPlayMarkAction(
            use: nil
        )
    }

    private mutating func resolveInterventionBonusPlayMarkAction(
        use: PlayerID?
    ) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()
        let coachID = turnContext.coachID.inverse

        guard
            let validDeclarations = turnContext.history.lastResult(
                { entry -> Set<ValidDeclaration>? in
                    guard
                        case .eligibleForInterventionBonusPlayMarkAction(
                            let validDeclarations,
                            _
                        ) = entry
                    else { return nil }
                    return validDeclarations
                }
            )
        else {
            throw GameError("No valid declaration")
        }

        let bonusPlay = BonusPlay.intervention

        if let playerID = use {

            _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)

            let playerDeclarations = validDeclarations.filter { $0.playerID == playerID }
            guard !playerDeclarations.isEmpty else {
                throw GameError("Invalid player")
            }

            let bonusPlayRequirements = playerDeclarations.map { $0.consumesBonusPlays }.toSet()
            if !bonusPlayRequirements.contains([]) {
                guard bonusPlayRequirements == [[.interference]] else {
                    throw GameError("Unexpected bonus plays")
                }
                _ = try useBonusPlay(bonusPlay: .interference, coachID: coachID)
            }

            return try declareMarkAction(
                playerID: playerID,
                isFree: true
            )
        }

        return try endAction()
    }
}
