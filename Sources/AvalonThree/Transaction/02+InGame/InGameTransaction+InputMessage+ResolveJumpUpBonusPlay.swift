//
//  InGameTransaction+InputMessage+ResolveJumpUpBonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func useJumpUpBonusPlayStandUpAction(playerID: PlayerID) throws -> Prompt? {

        let turnContext = try history.latestTurnContext()

        let bonusPlay = BonusPlay.jumpUp

        guard let player = table.getPlayer(id: playerID) else {
            throw GameError("No player")
        }

        guard
            playerID.coachID == turnContext.coachID,
            try playerCanDeclareAction(
                player: player,
                actionID: .standUp
            ) == .canDeclare(consumesBonusPlays: [])
        else {
            throw GameError("Invalid player")
        }

        _ = try useBonusPlay(bonusPlay: bonusPlay, coachID: playerID.coachID)
        return try declareStandUpAction(
            playerID: playerID,
            isFree: true
        )
    }

    mutating func declineJumpUpBonusPlayStandUpAction() throws -> Prompt? {
        return try endAction()
    }
}
