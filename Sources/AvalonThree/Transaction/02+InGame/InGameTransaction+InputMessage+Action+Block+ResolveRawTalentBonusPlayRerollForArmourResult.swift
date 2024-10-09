//
//  InGameTransaction+InputMessage+Action+Block+ResolveRawTalentBonusPlayRerollForArmourResult.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionUseRawTalentBonusPlayRerollForArmourResult() throws -> AddressedPrompt? {
        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
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

        return try useRawTalentBonusPlay(
            coachID: targetPlayerID.coachID,
            action: .blockActionRollForArmour
        )
    }

    mutating func blockActionDeclineRawTalentBonusPlayRerollForArmourResult() throws -> AddressedPrompt? {
        return try blockActionTargetPlayerInjured()
    }

    enum RawTalentAction {
        case blockActionRollDice
        case blockActionRollForArmour
        case passActionRollDie
        case hurlTeammateActionRollDie
    }

    mutating func useRawTalentBonusPlay(
        coachID: CoachID,
        action: RawTalentAction
    ) throws -> AddressedPrompt? {
        let bonusPlay = BonusPlay.rawTalent
        let card = try useBonusPlay(bonusPlay: bonusPlay, coachID: coachID)

        let prompt = try {
            switch action {
            case .blockActionRollDice:
                try blockActionRollDice()
            case .blockActionRollForArmour:
                try blockActionRollForArmour()
            case .passActionRollDie:
                try passActionRollDie()
            case .hurlTeammateActionRollDie:
                try hurlTeammateActionRollDie()
            }
        }()

        try discardActiveBonusPlay(
            card: card,
            coachID: coachID
        )

        return prompt
    }
}
