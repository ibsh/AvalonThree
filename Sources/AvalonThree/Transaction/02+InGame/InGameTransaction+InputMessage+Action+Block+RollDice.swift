//
//  InGameTransaction+InputMessage+Action+Block+RollDice.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func blockActionRollDice() throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()

        guard
            let actionContext = try turnContext.actionContexts().last,
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

        guard let playerSquare = player.square else {
            throw GameError("Player is in reserves")
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

        var claws: Int?

        var unmodifiedDice = blockDiceCount.reduce([BlockDieResult]()) { partialResult in
            partialResult + [randomizers.blockDie.rollBlockDie()]
        }

        if player.spec.skills.contains(.enforcer) {
            unmodifiedDice = unmodifiedDice.sorted { lhs, rhs in
                lhs.enforcerSortValue < rhs.enforcerSortValue
            }
        }

        if player.spec.skills.contains(.claws) {
            claws = randomizers.d6.roll()
        }

        events.append(
            .rolledForBlock(
                coachID: actionContext.coachID,
                results: BlockResults(
                    dice: unmodifiedDice,
                    claws: claws
                )
            )
        )

        if claws == TableConstants.clawsEffectiveD6Roll {

            // finish the action
            history.append(.blockTargetKnockedDown)
            history.append(.blockTargetInjured)

            targetPlayer.state = .prone(square: targetSquare)
            table.players.update(with: targetPlayer)

            guard let direction = playerSquare.direction(to: targetSquare) else {
                throw GameError("No block direction")
            }
            events.append(
                .playerBlocked(
                    playerID: player.id,
                    from: playerSquare,
                    to: targetSquare,
                    direction: direction,
                    targetPlayerID: targetPlayerID
                )
            )
            for assistingPlayerID in actionContext.history.compactMap({ entry -> PlayerID? in
                guard case .blockAssistingPlayer(let playerID) = entry else { return nil }
                return playerID
            }) {
                guard let square = table.getPlayer(id: assistingPlayerID)?.square else {
                    throw GameError("Assisting player is in reserves")
                }
                guard let direction = square.direction(to: targetSquare) else {
                    throw GameError("No assist direction")
                }
                events.append(
                    .playerAssistedBlock(
                        assistingPlayerID: assistingPlayerID,
                        from: square,
                        to: targetSquare,
                        direction: direction,
                        targetPlayerID: targetPlayerID,
                        blockingPlayerID: player.id
                    )
                )
            }
            events.append(
                .playerFellDown(
                    playerID: targetPlayerID,
                    playerSquare: targetSquare,
                    reason: .blocked
                )
            )

            try playerIsInjured(playerID: targetPlayerID, reason: .blocked)

            return try endBlockAction()
        }

        var modifiedDice = unmodifiedDice
        var modifications = [BlockRollModification]()

        modifiedDice = modifiedDice.map { result in
            var result = result

            // blocking player effects

            if actionContext.history.contains(.blockIsBomb), result == .shove {
                modifications.append(.playerThrewBomb)
                result = .miss
            }

            if player.spec.skills.contains(.hulkingBrute), [.tackle, .smash].contains(result) {
                modifications.append(.playerIsHulkingBrute)
                result = .kerrunch
            }

            if player.spec.skills.contains(.mightyBlow), result == .smash {
                modifications.append(.playerHasMightyBlow)
                result = .kerrunch
            }

            if player.spec.skills.contains(.insignificant), result == .tackle {
                modifications.append(.playerIsInsignificant)
                result = .miss
            }

            if player.spec.skills.contains(.titchy), result == .tackle {
                modifications.append(.playerIsTitchy)
                result = .miss
            }

            // target player effects

            if targetPlayer.spec.skills.contains(.hulkingBrute), result == .tackle {
                modifications.append(.opponentIsHulkingBrute)
                result = .miss
            }

            if targetPlayer.spec.skills.contains(.standFirm), result == .shove {
                modifications.append(.opponentHasStandFirm)
                result = .miss
            }

            return result
        }

        if player.spec.skills.contains(.enforcer) {
            modifiedDice = modifiedDice.sorted { lhs, rhs in
                lhs.enforcerSortValue < rhs.enforcerSortValue
            }
        }

        let results = BlockResults(
            dice: modifiedDice,
            claws: claws
        )

        if modifiedDice != unmodifiedDice {
            events.append(
                .changedBlockResults(
                    from: BlockResults(
                        dice: unmodifiedDice,
                        claws: claws
                    ),
                    to: results,
                    modifications: modifications.distinct()
                )
            )
        }

        history.append(.blockResults(results))

        if
            player.spec.skills.contains(.offensiveSpecialist),
            !actionContext.history.contains(
                .blockDieResultsEligibleForOffensiveSpecialistSkillReroll
            )
        {
            history.append(.blockDieResultsEligibleForOffensiveSpecialistSkillReroll)
            return AddressedPrompt(
                coachID: actionContext.coachID,
                prompt: .blockActionBlockDieResultsEligibleForOffensiveSpecialistSkillReroll(
                    player: PromptBoardPlayer(
                        id: actionContext.playerID,
                        square: playerSquare
                    ),
                    results: results,
                    maySelectResultToDecline: results.dice.count > 1
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
            ),
            !turnContext.history.contains(
                .usedBonusPlay(coachID: actionContext.coachID, bonusPlay: .rawTalent)
            )
        {
            history.append(.blockDieResultsEligibleForRawTalentBonusPlayReroll)
            return AddressedPrompt(
                coachID: actionContext.coachID,
                prompt: .blockActionBlockDieResultsEligibleForRawTalentBonusPlayReroll(
                    player: PromptBoardPlayer(
                        id: actionContext.playerID,
                        square: playerSquare
                    ),
                    results: results,
                    maySelectResultToDecline:
                        !player.spec.skills.contains(.enforcer) && results.dice.count > 1
                )
            )
        }

        // This implementation assumes that no enforcer is a bomber or offensive specialist.
        if player.spec.skills.contains(.enforcer) {
            return try blockActionSelectResult(dieIndex: 0)
        }

        if results.dice.count == 1 || Set(results.dice).count == 1 {
            return try blockActionSelectResult(dieIndex: 0)
        }

        return AddressedPrompt(
            coachID: actionContext.coachID,
            prompt: .blockActionSelectResult(
                player: PromptBoardPlayer(
                    id: actionContext.playerID,
                    square: playerSquare
                ),
                results: results
            )
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
