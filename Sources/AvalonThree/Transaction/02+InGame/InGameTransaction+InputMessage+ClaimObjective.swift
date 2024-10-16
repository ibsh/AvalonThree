//
//  InGameTransaction+InputMessage+ClaimObjective.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/24/24.
//

import Foundation

extension InGameTransaction {

    mutating func claimObjective(
        objectiveIndex: Int
    ) throws -> AddressedPrompt? {

        guard let objective = try table.objectives.getObjective(index: objectiveIndex) else {
            throw GameError("No objective")
        }

        let turnContext = try history.latestTurnContext()

        guard
            let entry = turnContext.history.last,
            case .choosingObjectiveToClaim(let objectiveIndices) = entry
        else {
            throw GameError("No history entry")
        }

        guard objectiveIndices.contains(objectiveIndex) else {
            throw GameError("Invalid objective")
        }

        let newHand = table.getHand(coachID: turnContext.coachID) + [objective]

        table.setHand(
            coachID: turnContext.coachID,
            hand: newHand
        )

        history.append(
            .claimedObjective(objectiveIndex: objectiveIndex)
        )
        try table.objectives.remove(objectiveIndex)
        events.append(
            .claimedObjective(
                coachID: turnContext.coachID,
                objectiveIndex: objectiveIndex,
                objective: .open(card: objective),
                objectives: table.objectives.toWrappedObjectives(),
                hand: newHand.map { .open(card: $0) },
                active: table.getActiveBonuses(coachID: turnContext.coachID)
            )
        )

        if objective.challenge.scoreIncrement != 0 {

            table.incrementScore(
                coachID: turnContext.coachID,
                increment: objective.challenge.scoreIncrement
            )

            events.append(
                .scoreUpdated(
                    coachID: turnContext.coachID,
                    increment: objective.challenge.scoreIncrement,
                    total: table.getScore(coachID: turnContext.coachID)
                )
            )
        }

        switch objective.bonusPlay {
        case .multiBall:
            try multiBall(objective: objective, coachID: turnContext.coachID)
        case .bribedRef:
            _ = try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .nufflesBlessing:
            _ = try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .readyToGo:
            _ = try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
        case .yourTimeToShine:
            _ = try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: turnContext.coachID)
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

        let claimedObjectiveCount: Int = turnContext.history
            .reduce(0) { partialResult, entry in
                guard case .claimedObjective = entry else {
                    return partialResult
                }
                return partialResult + 1
            }

        if claimedObjectiveCount == 3 {
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
                    increment: TableConstants.cleanSweepScoreValue,
                    total: table.getScore(coachID: turnContext.coachID)
                )
            )
        }
    }

    private mutating func multiBall(objective: ChallengeCard, coachID: CoachID) throws {
        let card = try useBonusPlay(bonusPlay: objective.bonusPlay, coachID: coachID)
        try addNewBall()
        try addNewBall()
        try discardActiveBonusPlay(card: card, coachID: coachID)
    }
}
