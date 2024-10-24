//
//  InGameTransaction+CheckObjectives.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func checkObjectives(
        postTouchdown: Bool
    ) throws -> AddressedPrompt? {

        let turnContext = try history.latestTurnContext()
        let actionContexts = try turnContext.actionContexts()

        guard !actionContexts.contains(where: { !$0.isFinished }) else {
            throw GameError("Unfinished actions")
        }

        guard let lastActionContext = actionContexts.last else {
            // No action to check yet
            return nil
        }

        guard lastActionContext.coachID == turnContext.coachID else {
            // Can't earn objectives out of turn
            return nil
        }

        guard
            !turnContext.historyEntriesSinceLastActionFinished.contains(where: { entry in
                guard case .choosingObjectiveToClaim = entry else { return false }
                return true
            })
        else {
            // Already been claimed
            return nil
        }

        let objectives = table.objectives.notEmpty
        guard !objectives.isEmpty else {
            return nil
        }

        var canClaim = try objectives.filter {
            guard $0.value.challenge.checkedPostTouchdown == postTouchdown else { return false }
            return try canClaimChallenge(
                challenge: $0.value.challenge,
                turnContext: turnContext,
                lastActionContext: lastActionContext
            )
        }

        if canClaim.isEmpty {
            return nil
        }

        // Note that this logic relies on there being only one "Last chance" challenge in the deck.
        if canClaim.count > 1 {
            canClaim = canClaim.filter {
                $0.value.challenge != .lastChance
            }
        }

        history.append(.choosingObjectiveToClaim(objectiveIndices: canClaim.map { $0.0 }))
        return AddressedPrompt(
            coachID: turnContext.coachID,
            prompt: .earnedObjective(
                indices: canClaim.map { $0.0 },
                objectives: table.objectives.toWrappedObjectives()
            )
        )
    }
}

extension InGameTransaction {

    private func canClaimChallenge(
        challenge: Challenge,
        turnContext: TurnContext,
        lastActionContext: ActionContext
    ) throws -> Bool {
        switch challenge {
        case .breakSomeBones: try canClaimBreakSomeBones(turnContext, lastActionContext)
        case .freeUpTheBall: try canClaimFreeUpTheBall(turnContext, lastActionContext)
        case .gangUp: try canClaimGangUp(turnContext, lastActionContext)
        case .getMoving: try canClaimGetMoving(turnContext, lastActionContext)
        case .getTheBall: try canClaimGetTheBall(turnContext, lastActionContext)
        case .getTogether: try canClaimGetTogether(turnContext, lastActionContext)
        case .makeARiskyPass: try canClaimMakeARiskyPass(turnContext, lastActionContext)
        case .moveTheBall: try canClaimMoveTheBall(turnContext, lastActionContext)
        case .showboatForTheCrowd: try canClaimShowboatForTheCrowd(turnContext, lastActionContext)
        case .showNoFear: try canClaimShowNoFear(turnContext, lastActionContext)
        case .showUsACompletion: try canClaimShowUsACompletion(turnContext, lastActionContext)
        case .spreadOut: try canClaimSpreadOut(turnContext, lastActionContext)
        case .takeThemDown: try canClaimTakeThemDown(turnContext, lastActionContext)
        case .tieThemUp: try canClaimTieThemUp(turnContext, lastActionContext)
        case .breakTheirLines: try canClaimBreakTheirLines(turnContext, lastActionContext)
        case .causeSomeCarnage: try canClaimCauseSomeCarnage(turnContext, lastActionContext)
        case .goDeep: try canClaimGoDeep(turnContext, lastActionContext)
        case .lastChance: try canClaimLastChance(turnContext, lastActionContext)
        case .pileOn: try canClaimPileOn(turnContext, lastActionContext)
        case .playAsATeam: try canClaimPlayAsATeam(turnContext, lastActionContext)
        case .showOffALittle: try canClaimShowOffALittle(turnContext, lastActionContext)
        case .showSomeGrit: try canClaimShowSomeGrit(turnContext, lastActionContext)
        case .showThemHowItsDone: try canClaimShowThemHowItsDone(turnContext, lastActionContext)
        case .rookieBonus: throw GameError("The rookie bonus card should never be an objective")
        }
    }

    private func canClaimBreakSomeBones(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {
        return lastActionContext.actionID == .block
        && lastActionContext.history.contains(.blockTargetInjured)
    }

    private func canClaimFreeUpTheBall(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        let ballFilter: (Ball) -> Bool = { ball in
            switch ball.state {
            case .held(let playerID):
                playerID.coachID != lastActionContext.coachID
            case .loose:
                false
            }
        }

        let oldBallsIDs = lastActionContext.snapshot.balls.filter(ballFilter).map { $0.id }
        let newBallsIDs = table.balls.filter(ballFilter).map { $0.id }

        return oldBallsIDs.contains(where: { !newBallsIDs.contains($0) })
    }

    private func canClaimGangUp(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {
        return lastActionContext.actionID == .block
        && lastActionContext.history.contains(.blockAssisted)
        && lastActionContext.history.contains(.blockTargetKnockedDown)
    }

    private func canClaimGetMoving(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        return try lastActionContext.actionID == .run
        && turnContext.actionContexts()
            .filter { actionContext in
                guard
                    actionContext.coachID == lastActionContext.coachID,
                    actionContext.actionID == .run
                else {
                    return false
                }
                return true
            }
            .count >= TableConstants.getMovingRunCount
    }

    private func canClaimGetTheBall(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        let ballFilter: (Ball) -> Bool = { ball in
            switch ball.state {
            case .held(let playerID):
                playerID.coachID == lastActionContext.coachID
            case .loose:
                false
            }
        }

        for actionContext in try turnContext.actionContexts() {
            let oldBallIDs = actionContext.snapshot.balls.filter(ballFilter).map { $0.id }.toSet()
            let newBallIDs = table.balls.filter(ballFilter).map { $0.id }.toSet()
            if newBallIDs.subtracting(oldBallIDs).isEmpty { return false }
        }

        return true
    }

    private func canClaimGetTogether(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        guard
            [.run, .mark, .sidestep].contains(lastActionContext.actionID),
            let square = player.isStanding
        else {
            return false
        }

        return table
            .playersInSquares(square.adjacentSquares)
            .filter {
                $0.coachID == player.coachID
                && $0.index != player.index
                && $0.isStanding != nil
            }
            .count >= TableConstants.getTogetherTeammateCount
    }

    private func canClaimMakeARiskyPass(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {
        guard [.pass, .hurlTeammate].contains(lastActionContext.actionID) else {
            return false
        }

        var success = false
        var negativeModifier = false

        for entry in lastActionContext.history {
            switch entry {
            case .passSuccessful,
                 .hurlTeammateSuccessful:
                success = true
            case .passNegativeModifier,
                 .hurlTeammateNegativeModifier:
                negativeModifier = true
            default:
                break
            }
        }

        return success && negativeModifier
    }

    private func canClaimMoveTheBall(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard [.run, .pass, .hurlTeammate].contains(lastActionContext.actionID) else {
            return false
        }

        let oldBallYLocations = try lastActionContext.snapshot.balls
            .reduce([Int: Int]()) { partialResult, ball in
                switch ball.state {
                case .held(let playerID):
                    guard
                        let player = lastActionContext.snapshot
                            .players
                            .first(where: { $0.id == playerID })
                    else {
                        throw GameError("No player")
                    }
                    guard let playerSquare = player.square else {
                        throw GameError("No square")
                    }
                    return partialResult.adding(
                        key: ball.id,
                        value: playerSquare.y
                    )
                case .loose(let square):
                    return partialResult.adding(
                        key: ball.id,
                        value: square.y
                    )
                }
            }

        let newBallYLocations = try table.balls
            .reduce([Int: Int]()) { partialResult, ball in
                switch ball.state {
                case .held(let playerID):
                    guard let player = table.getPlayer(id: playerID) else {
                        throw GameError("No player")
                    }
                    guard let playerSquare = player.square else {
                        throw GameError("No square")
                    }
                    return partialResult.adding(
                        key: ball.id,
                        value: playerSquare.y
                    )
                case .loose(let square):
                    return partialResult.adding(
                        key: ball.id,
                        value: square.y
                    )
                }
            }

        var newBallYDeltas = [Int: Int]()
        newBallYLocations.forEach { newBallID, newBallYLocation in
            if let oldBallYLocation = oldBallYLocations[newBallID] {
                newBallYDeltas[newBallID] = newBallYLocation - oldBallYLocation
            }
        }

        let delta = TableConstants.moveTheBallTargetDeltaY
        return newBallYDeltas.values.contains(
            where: { value in
                switch lastActionContext.coachID {
                case .home: return value <= -delta
                case .away: return value >= delta
                }
            }
        )
    }

    private func canClaimShowboatForTheCrowd(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        return turnContext.historyEntriesSinceLastActionFinished.contains(.touchdown)
    }

    private func canClaimShowNoFear(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        guard
            let square = player.square,
            table.boardSpecID.spec.trapdoorSquares.contains(square),
            table.balls.contains(where: { ball in
                switch ball.state {
                case .held(let playerID):
                    playerID.coachID != lastActionContext.coachID
                case .loose:
                    false
                }
            })
        else { return false }

        return true
    }

    private func canClaimShowUsACompletion(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {
        guard [.pass, .hurlTeammate].contains(lastActionContext.actionID) else {
            return false
        }

        var success = false
        var notAHandoff = false

        for entry in lastActionContext.history {
            switch entry {
            case .passTarget(let target):
                notAHandoff = target.distance != .handoff
            case .passSuccessful:
                success = true
            case .hurlTeammateSuccessful:
                success = true
                notAHandoff = true
            default:
                break
            }
        }

        return success && notAHandoff
    }

    private func canClaimSpreadOut(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard
            [.run, .sidestep].contains(lastActionContext.actionID)
        else { return false }

        let squares = Set(
            table
                .players(coachID: lastActionContext.coachID)
                .compactMap { $0.square }
        )

        return !squares.contains(where: { square in
            !square.adjacentSquares.toSet().subtracting([square]).isDisjoint(with: squares)
        })
    }

    private func canClaimTakeThemDown(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {
        return lastActionContext.actionID == .block
        && lastActionContext.history.contains(.blockTargetKnockedDown)
    }

    private func canClaimTieThemUp(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard
            lastActionContext.actionID == .mark,
            table
                .players(coachID: lastActionContext.coachID)
                .count(where: { player in
                    table.playerIsMarked(player) != nil
                }) >= TableConstants.tieThemUpMarkedTeammatesCount,
            table
                .players(coachID: lastActionContext.coachID.inverse)
                .count(where: { player in
                    table.playerIsMarked(player) != nil
                }) >= TableConstants.tieThemUpMarkedOpponentsCount
        else {
            return false
        }

        return true
    }

    private func canClaimBreakTheirLines(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard let player = table.getPlayer(id: lastActionContext.playerID) else {
            throw GameError("No player")
        }

        return lastActionContext.actionID == .block
        && lastActionContext.history.contains(.blockTargetKnockedDown)
        && table.playerHasABall(player) != nil
    }

    private func canClaimCauseSomeCarnage(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard
            lastActionContext.actionID == .block,
            lastActionContext.history.contains(.blockTargetInjured)
        else {
            return false
        }

        let olderActionContexts = try turnContext.actionContexts().dropLast()
        return olderActionContexts.contains { actionContext in
            return actionContext.actionID == .block
            &&
            actionContext.coachID == lastActionContext.coachID
            &&
            actionContext.history.contains(.blockTargetKnockedDown)
        }
    }

    private func canClaimGoDeep(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        let targetY = {
            switch lastActionContext.coachID {
            case .home:
                Square.Constants.yRange.first
            case .away:
                Square.Constants.yRange.last
            }
        }()

        guard let targetY else {
            throw GameError("No Y target")
        }

        return table
            .players(coachID: lastActionContext.coachID)
            .count(where: { player in
                guard let playerSquare = table.playerIsOpen(player) else { return false }
                return abs(playerSquare.y - targetY) <= TableConstants.goDeepTargetDeltaY
            }) >= TableConstants.goDeepPlayerCount
    }

    private func canClaimLastChance(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        return table.getScore(coachID: lastActionContext.coachID)
        + TableConstants.lastChanceScoreDelta
        <= table.getScore(coachID: lastActionContext.coachID.inverse)
    }

    private func canClaimPileOn(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        return lastActionContext.actionID == .block
        && lastActionContext.history.contains(.blockTargetKnockedDown)
        && table.players(coachID: lastActionContext.coachID.inverse)
            .count(where: { $0.isInReserves })
        >= TableConstants.pileOnOpponentsInReserveCount
    }

    private func canClaimPlayAsATeam(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        var playerIndices = Set<Int>()
        var actionIDs = Set<ActionID>()

        try turnContext.actionContexts().forEach { actionContext in
            guard
                actionContext.coachID == lastActionContext.coachID,
                !actionContext.isCancelled
            else { return }
            playerIndices.insert(actionContext.playerID.index)
            if !actionIDs.contains(where: { $0.isEquivalentTo(actionContext.actionID) }) {
                actionIDs.insert(actionContext.actionID)
            }
        }

        return playerIndices.count >= TableConstants.playAsATeamCount
        && actionIDs.count >= TableConstants.playAsATeamCount
    }

    private func canClaimShowOffALittle(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        guard [.pass, .hurlTeammate].contains(lastActionContext.actionID) else {
            return false
        }

        var success = false
        var longDistance = false

        for entry in lastActionContext.history {
            switch entry {
            case .passTarget(let target):
                longDistance = target.distance == .long
            case .passSuccessful:
                success = true
            case .hurlTeammateTarget(let target):
                longDistance = target.distance == .long
            case .hurlTeammateSuccessful:
                success = true
            default:
                break
            }
        }

        guard success && longDistance else { return false }

        let olderActionContexts = try turnContext.actionContexts().dropLast()
        return olderActionContexts.contains { actionContext in
            var success = false
            var notAHandoff = false
            guard
                actionContext.actionID.isEquivalentTo(.pass),
                actionContext.coachID == lastActionContext.coachID
            else { return false }
            for entry in actionContext.history {
                switch entry {
                case .passTarget(let target):
                    notAHandoff = target.distance != .handoff
                case .passSuccessful:
                    success = true
                case .hurlTeammateSuccessful:
                    success = true
                default:
                    break
                }
            }
            return success && notAHandoff
        }
    }

    private func canClaimShowSomeGrit(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        return table.getScore(coachID: lastActionContext.coachID)
        + TableConstants.showSomeGritScoreDelta
        <= table.getScore(coachID: lastActionContext.coachID.inverse)
        && turnContext.history.contains(.declareEmergencyReservesAction)
    }

    private func canClaimShowThemHowItsDone(
        _ turnContext: TurnContext,
        _ lastActionContext: ActionContext
    ) throws -> Bool {

        return try turnContext.actionContexts().count(where: { action in
            action.playerID == lastActionContext.playerID
            && !action.isFree
            && !action.isCancelled
        }) >= TableConstants.showThemHowItsDoneCount
    }
}
