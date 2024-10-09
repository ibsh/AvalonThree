//
//  InGameTransaction+InputMessage+ResolveShadowBonusPlayExtraMove.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useShadowBonusPlayExtraMove(playerID: PlayerID) throws -> AddressedPrompt? {
        return try resolveShadowBonusPlayExtraMove(use: playerID)
    }

    mutating func declineShadowBonusPlayExtraMove() throws -> AddressedPrompt? {
        return try resolveShadowBonusPlayExtraMove(use: nil)
    }

    private mutating func resolveShadowBonusPlayExtraMove(
        use: PlayerID?
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        let bonusPlay = BonusPlay.shadow
        let coachID = turnContext.coachID.inverse

        if let playerID = use {

            guard
                playerID.coachID == coachID,
                let (validPlayers, square) = turnContext
                    .historyEntriesSinceLastActionFinished
                    .lastResult(
                        { entry -> (Set<PlayerID>, Square)? in
                            guard case .eligibleForShadowBonusPlayExtraMove(
                                let validPlayers,
                                let square
                            ) = entry else {
                                return nil
                            }
                            return (validPlayers, square)
                        }
                    ),
                validPlayers.contains(playerID)
            else {
                throw GameError("Invalid player")
            }

            let card = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)

            try playerMovesIntoSquare(
                playerID: playerID,
                newSquare: square,
                isFinalSquare: true,
                reason: .shadow
            )

            try discardActiveBonusPlay(card: card, coachID: coachID)
        }

        return try endAction()
    }
}
