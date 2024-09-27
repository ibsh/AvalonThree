//
//  InGameTransaction+InputMessage+Action+Pass+RollDie.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

extension InGameTransaction {

    mutating func passActionRollDie() throws -> Prompt? {

        guard
            let actionContext = try history.latestTurnContext().actionContexts().last,
            !actionContext.isFinished,
            let target = actionContext.history.lastResult(
                { entry -> PassTarget? in
                    guard case .passTarget(let target) = entry else { return nil }
                    return target
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

        guard var effectivePassStat = player.spec.pass else {
            throw GameError("Player has no pass stat")
        }

        guard var ball = table.playerHasABall(player) else {
            throw GameError("Player has no ball")
        }

        if
            table.getHand(coachID: actionContext.coachID).contains(
                where: { $0.bonusPlay == .pro }
            ),
            !actionContext.history.contains(.passActionEligibleForProBonusPlay)
        {
            history.append(.passActionEligibleForProBonusPlay)

            return Prompt(
                coachID: actionContext.coachID,
                payload: .passActionEligibleForProBonusPlay(
                    playerID: actionContext.playerID
                )
            )
        }

        if table.getActiveBonuses(coachID: actionContext.coachID).contains(
            where: { $0.bonusPlay == .accuratePass }
        ) {
            effectivePassStat = TableConstants.accuratePassBonusPlayPassStat
        }

        var modifier = 0
        var modifications = [PassRollModification]()

        switch target.distance {
        case .handoff:

            guard let targetPlayer = table.getPlayer(id: target.targetPlayerID) else {
                throw GameError("No target player")
            }

            guard let direction = playerSquare.direction(to: target.targetSquare) else {
                throw GameError("No handoff direction")
            }

            if targetPlayer.spec.pass != nil {

                ball.state = .held(playerID: target.targetPlayerID)
                table.balls.update(with: ball)

                history.append(.passSuccessful)
                history.append(.actionFinished)

                events.append(
                    .playerHandedOffBall(
                        playerID: player.id,
                        from: playerSquare,
                        to: target.targetSquare,
                        direction: direction,
                        ballID: ball.id
                    )
                )
                events.append(
                    .playerCaughtHandoff(
                        playerID: target.targetPlayerID,
                        in: target.targetSquare,
                        ballID: ball.id
                    )
                )

            } else {

                ball.state = .loose(square: target.targetSquare)
                table.balls.update(with: ball)

                history.append(.actionFinished)

                events.append(
                    .playerHandedOffBall(
                        playerID: player.id,
                        from: playerSquare,
                        to: target.targetSquare,
                        direction: direction,
                        ballID: ball.id
                    )
                )
                events.append(
                    .playerFailedCatch(
                        playerID: target.targetPlayerID,
                        in: target.targetSquare,
                        ballID: ball.id
                    )
                )

                try ballComesLoose(id: ball.id, square: target.targetSquare)
                try bounceBall(id: ball.id)
            }

            return try endAction()

        case .short:
            break

        case .long:
            modifier -= 1
            modifications.append(.longDistance)
        }

        if !target.obstructingSquares.isEmpty {
            modifier -= 1
            modifications.append(.obstructed)
        }

        if !target.markedTargetSquares.isEmpty {
            modifier -= 1
            modifications.append(.targetPlayerMarked)
        }

        modifier = max(-1, modifier)

        let randomizer: DXRandomizing = {
            let bonusPlays: Set<BonusPlay> = [.passingPlay, .pro]
            if table.getActiveBonuses(
                coachID: actionContext.coachID
            ).contains(
                where: { bonusPlays.contains($0.bonusPlay) }
            ) {
                return randomizers.d8
            } else {
                return randomizers.d6
            }
        }()

        let unmodifiedRoll = randomizer.roll()
        events.append(
            .rolledForPass(
                coachID: actionContext.coachID,
                die: randomizer.die,
                unmodified: unmodifiedRoll
            )
        )

        let modifiedRoll: Int

        if unmodifiedRoll >= TableConstants.rollOfSix || modifier == 0 {
            modifiedRoll = unmodifiedRoll
        } else {
            modifiedRoll = (unmodifiedRoll + modifier).clamp(randomizer.range)
            events.append(
                .changedPassResult(
                    die: randomizer.die,
                    unmodified: unmodifiedRoll,
                    modified: modifiedRoll,
                    modifications: modifications
                )
            )
        }

        if modifier < 0 {
            history.append(.passNegativeModifier)
        }

        history.append(
            .passRolled(
                effectivePassStat: effectivePassStat,
                unmodifiedRoll: unmodifiedRoll,
                modifiedRoll: modifiedRoll
            )
        )

        if
            !actionContext.history.contains(.passResultEligibleForRawTalentBonusPlayReroll),
            table.getHand(coachID: player.coachID).contains(where: { $0.bonusPlay == .rawTalent })
        {
            history.append(.passResultEligibleForRawTalentBonusPlayReroll)

            return Prompt(
                coachID: player.coachID,
                payload: .passActionResultEligibleForRawTalentBonusPlayReroll(
                    playerID: player.id,
                    result: modifiedRoll
                )
            )
        }

        return try resolvePassAction()
    }
}
