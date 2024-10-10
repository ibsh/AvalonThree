//
//  InGameTransaction+InputMessage+Action+Block+PrepareToRollDice.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionPrepareToRollDice() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let actionContext = try turnContext.actionContexts().last,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let playerSquare = table.getPlayer(id: actionContext.playerID)?.square else {
            throw GameError("Player is in reserves")
        }

        guard let targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetPlayerSquare = targetPlayer.square else {
            throw GameError("Target player is in reserves")
        }

        if
            table.getHand(coachID: targetPlayerID.coachID).contains(
                where: { $0.bonusPlay == .stepAside }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .stepAside)
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForStepAsideBonusPlaySidestepAction
            ),
            try playerCanDeclareAction(
                player: targetPlayer,
                actionID: .sidestep
            ) == .canDeclare(consumesBonusPlays: [])
        {
            history.append(.blockDieResultsEligibleForStepAsideBonusPlaySidestepAction)
            return AddressedPrompt(
                coachID: targetPlayerID.coachID,
                prompt: .blockActionEligibleForStepAsideBonusPlaySidestepAction(
                    player: PromptBoardPlayer(
                        id: targetPlayerID,
                        square: targetPlayerSquare
                    )
                )
            )
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .bodyCheck }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .bodyCheck)
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForBodyCheckBonusPlay
            )
        {
            history.append(.blockDieResultsEligibleForBodyCheckBonusPlay)
            return AddressedPrompt(
                coachID: actionContext.coachID,
                prompt: .blockActionEligibleForBodyCheckBonusPlay(
                    player: PromptBoardPlayer(
                        id: actionContext.playerID,
                        square: playerSquare
                    )
                )
            )
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .theKidsGotMoxy }
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: targetPlayerID.coachID, bonusPlay: .theKidsGotMoxy)
            ),
            !actionContext.history.contains(
                .blockAssisted
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForTheKidsGotMoxyBonusPlay
            )
        {
            history.append(.blockDieResultsEligibleForTheKidsGotMoxyBonusPlay)
            return AddressedPrompt(
                coachID: actionContext.coachID,
                prompt: .blockActionEligibleForTheKidsGotMoxyBonusPlay(
                    player: PromptBoardPlayer(
                        id: actionContext.playerID,
                        square: playerSquare
                    )
                )
            )
        }

        return try blockActionRollDice()
    }
}
