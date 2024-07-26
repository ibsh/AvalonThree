//
//  InGameTransaction+InputMessage+DeclareAction.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func declareAction(
        declaration: ActionDeclaration,
        consumesBonusPlays: [BonusPlay],
        isFree: Bool
    ) throws -> Prompt? {

        guard
            try !history.latestTurnContext().actionContexts().contains(
                where: { !$0.isFinished }
            )
        else {
            throw GameError("Unfinished actions")
        }

        guard
            try validDeclarations().contains(
                ValidDeclaration(declaration: declaration, consumesBonusPlays: consumesBonusPlays)
            )
        else {
            throw GameError("No matching declaration")
        }

        for bonusPlay in consumesBonusPlays {
            try useBonusPlay(bonusPlay: bonusPlay, coachID: declaration.coachID)
        }

        let prompt = try {
            switch declaration.actionID {
            case .run:
                return try declareRunAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .mark:
                return try declareMarkAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .pass:
                return try declarePassAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .hurlTeammate:
                return try declareHurlTeammateAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .foul:
                return try declareFoulAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .block:
                return try declareBlockAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .sidestep:
                return try declareSidestepAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .standUp:
                return try declareStandUpAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )

            case .reserves:
                return try declareReservesAction(
                    playerID: declaration.playerID,
                    isFree: isFree
                )
            }
        }()

        return try prompt ?? endAction()
    }
}
