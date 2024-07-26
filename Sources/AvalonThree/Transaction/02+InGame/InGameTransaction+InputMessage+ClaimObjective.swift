//
//  InGameTransaction+InputMessage+ClaimObjective.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func claimObjective(
        objectiveID: ObjectiveID
    ) throws -> Prompt? {

        guard let objective = table.objectives.getObjective(id: objectiveID) else {
            throw GameError("No objective")
        }

        let turnContext = try history.latestTurnContext()

        guard
            let entry = turnContext.history.last,
            case .choosingObjectiveToClaim(let objectiveIDs) = entry
        else {
            throw GameError("No history entry")
        }

        guard objectiveIDs.contains(objectiveID) else {
            throw GameError("Invalid objective")
        }

        history.append(
            .claimedObjective(objectiveID: objectiveID)
        )
        table.objectives.remove(objectiveID)
        events.append(.claimedObjective(coachID: turnContext.coachID, objectiveID: objectiveID))

        if objective.challenge.scoreIncrement != 0 {

            table.incrementScore(
                coachID: turnContext.coachID,
                increment: objective.challenge.scoreIncrement
            )

            events.append(
                .scoreUpdated(
                    coachID: turnContext.coachID,
                    increment: objective.challenge.scoreIncrement
                )
            )
        }

        table.setHand(
            coachID: turnContext.coachID,
            hand: table.getHand(coachID: turnContext.coachID) + [objective]
        )

        switch objective.bonusPlay {
        case .multiBall:
            try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
            try multiBall()
        case .bribedRef:
            try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .nufflesBlessing:
            try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .readyToGo:
            try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .yourTimeToShine:
            try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .accuratePass,
             .blitz,
             .blockingPlay,
             .defensivePlay,
             .distraction,
             .divingTackle,
             .dodge,
             .inspiration,
             .interference,
             .intervention,
             .jumpUp,
             .rawTalent,
             .reserves,
             .shadow,
             .sprint,
             .stepAside,
             .passingPlay,
             .toughEnough,
             .absoluteCarnage,
             .absolutelyNails,
             .bladedKnuckleDusters,
             .bodyCheck,
             .comboPlay,
             .getInThere,
             .hailMaryPass,
             .legUp,
             .nervesOfSteel,
             .pro,
             .shoulderCharge,
             .theKidsGotMoxy:
            break
        }

        try checkForCleanSweep()

        if objective.bonusPlay != .legUp {
            try checkForLegUpBonusPlay()
        }

        return try endAction()
    }

    private mutating func checkForCleanSweep() throws {
        let turnContext = try history.latestTurnContext()

        let claimedObjectives: [ObjectiveID] = turnContext.history
            .compactMap { entry in
                guard case .claimedObjective(let objectiveID) = entry else {
                    return nil
                }
                return objectiveID
            }

        if claimedObjectives.contains(.first),
            claimedObjectives.contains(.second),
            claimedObjectives.contains(.third)
        {
            events.append(
                .earnedCleanSweep(coachID: turnContext.coachID)
            )
            table.incrementScore(
                coachID: turnContext.coachID,
                increment: TableConstants.cleanSweepScoreValue
            )
            events.append(
                .scoreUpdated(
                    coachID: turnContext.coachID,
                    increment: TableConstants.cleanSweepScoreValue
                )
            )
        }
    }

    private mutating func multiBall() throws {
        try addNewBall()
        try addNewBall()
    }
}
