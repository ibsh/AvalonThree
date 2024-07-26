//
//  InGameTransaction+InputMessage+Action+Block+RollDice.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionRollDice() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            actionContext.actionID == .block,
            !actionContext.isFinished,
            let targetPlayerID = actionContext.history.lastResult(
                { entry -> PlayerID? in
                    guard case .blockTarget(let targetPlayerID) = entry else { return nil }
                    return targetPlayerID
                }
            ),
            let blockDiceCount = actionContext.history.lastResult(
                { entry -> Int? in
                    guard case .blockDiceCount(let blockDiceCount) = entry else { return nil }
                    return blockDiceCount
                }
            )
        else {
            throw GameError("No action in history")
        }

        guard let player = table.getPlayer(id: actionContext.playerID) else {
            throw GameError("No player")
        }

        guard var targetPlayer = table.getPlayer(id: targetPlayerID) else {
            throw GameError("No target player")
        }

        guard let targetSquare = targetPlayer.square else {
            throw GameError("No target player square")
        }

        guard blockDiceCount > 0 else {
            throw GameError("No block dice")
        }

        var clawsResult: Int?

        if player.spec.skills.contains(.claws) {
            let result = randomizers.d6.roll()
            clawsResult = result
            events.append(.rolledForClaws(result: result))
            if result == TableConstants.clawsEffectiveD6Roll {

                // finish the action
                history.append(.blockTargetKnockedDown)
                history.append(.blockTargetInjured)

                targetPlayer.state = .prone(square: targetSquare)
                table.players.update(with: targetPlayer)
                events.append(.playerBlocked(playerID: player.id, square: targetSquare))
                for assistingPlayerID in actionContext.history.compactMap({ entry -> PlayerID? in
                    guard case .blockAssistingPlayer(let playerID) = entry else { return nil }
                    return playerID
                }) {
                    events.append(
                        .playerAssistedBlock(playerID: assistingPlayerID, square: targetSquare)
                    )
                }
                events.append(.playerFellDown(playerID: targetPlayerID, reason: .blocked))

                try playerIsInjured(playerID: targetPlayerID, reason: .blocked)

                return try endBlockAction()
            }
        }

        let unmodifiedResults = blockDiceCount.reduce([BlockDieResult]()) { partialResult in
            partialResult + [randomizers.blockDie.rollBlockDie()]
        }

        events.append(
            .rolledForBlock(results: unmodifiedResults)
        )

        var results = unmodifiedResults
        var modifications = Set<BlockRollModification>()

        results = results.map { result in
            var result = result

            // blocking player effects

            if actionContext.history.contains(.blockIsBomb), result == .shove {
                modifications.insert(.playerThrewBomb)
                result = .miss
            }

            if player.spec.skills.contains(.hulkingBrute), [.tackle, .smash].contains(result) {
                modifications.insert(.playerIsHulkingBrute)
                result = .kerrunch
            }

            if player.spec.skills.contains(.mightyBlow), result == .smash {
                modifications.insert(.playerHasMightyBlow)
                result = .kerrunch
            }

            if player.spec.skills.contains(.insignificant), result == .tackle {
                modifications.insert(.playerIsInsignificant)
                result = .miss
            }

            if player.spec.skills.contains(.titchy), result == .tackle {
                modifications.insert(.playerIsTitchy)
                result = .miss
            }

            // target player effects

            if targetPlayer.spec.skills.contains(.hulkingBrute), result == .tackle {
                modifications.insert(.opponentIsHulkingBrute)
                result = .miss
            }

            if targetPlayer.spec.skills.contains(.standFirm), result == .shove {
                modifications.insert(.opponentHasStandFirm)
                result = .miss
            }

            return result
        }

        if results != unmodifiedResults {
            events.append(
                .changedBlockResults(
                    results: results,
                    modifications: modifications
                )
            )
        }

        if player.spec.skills.contains(.enforcer) {
            results = results.sorted { lhs, rhs in
                lhs.enforcerSortValue < rhs.enforcerSortValue
            }
        }

        history.append(.blockResults(results))

        if
            player.spec.skills.contains(.offensiveSpecialist),
            !actionContext.history.contains(
                .blockDieResultsEligibleForOffensiveSpecialistSkillReroll
            )
        {
            history.append(.blockDieResultsEligibleForOffensiveSpecialistSkillReroll)
            return Prompt(
                coachID: actionContext.coachID,
                payload: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    playerID: actionContext.playerID,
                    results: results
                )
            )
        }

        if
            table.getHand(coachID: player.coachID).contains(where: { $0.bonusPlay == .rawTalent }),
            !actionContext.history.contains(
                .blockDieResultsEligibleForOffensiveSpecialistSkillReroll
            ),
            !actionContext.history.contains(
                .blockDieResultsEligibleForRawTalentBonusPlayReroll
            )
        {
            history.append(.blockDieResultsEligibleForRawTalentBonusPlayReroll)
            return Prompt(
                coachID: actionContext.coachID,
                payload: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    playerID: actionContext.playerID,
                    results: results,
                    clawsResult: clawsResult,
                    maySelectResultToDecline:
                        !player.spec.skills.contains(.enforcer) && results.count > 1
                )
            )
        }

        // This implementation assumes that no enforcer is a bomber or offensive specialist.
        if player.spec.skills.contains(.enforcer) {
            return try blockActionSelectResult(result: results[0])
        }

        if results.count == 1 || Set(results).count == 1 {
            return try blockActionSelectResult(result: results[0])
        }

        return Prompt(
            coachID: actionContext.coachID,
            payload: .blockActionSelectResult(playerID: actionContext.playerID, results: results)
        )
    }
}

extension BlockDieResult {
    fileprivate var enforcerSortValue: Int {
        switch self {
        case .shove: 0
        case .smash: 1
        case .kerrunch: 2
        case .tackle: 3
        case .miss: 4
        }
    }
}
