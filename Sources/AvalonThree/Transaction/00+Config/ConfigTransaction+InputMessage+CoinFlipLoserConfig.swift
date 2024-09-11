//
//  ConfigTransaction+InputMessage+CoinFlipLoserConfig.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func coinFlipLoserConfig(
        coinFlipLoserConfig: CoinFlipLoserConfig
    ) throws -> Prompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("No coin flip")
        }

        guard let coinFlipWinnerConfig = config.coinFlipWinnerConfig else {
            throw GameError("Second coach has not configured yet")
        }

        guard config.coinFlipLoserConfig == nil else {
            throw GameError("First coach has already configured")
        }

        events.append(.coinFlipLoserConfigured(config: coinFlipLoserConfig))

        let coinFlipLoserPlayerConfigs = coinFlipLoserConfig.teamID.spec
            .playerConfigs(coachID: coinFlipWinnerCoachID.inverse)

        let coinFlipWinnerPlayerConfigs = coinFlipWinnerConfig.teamID.spec
            .playerConfigs(coachID: coinFlipWinnerCoachID)

        let playerConfigs = coinFlipLoserPlayerConfigs.union(coinFlipWinnerPlayerConfigs)

        var deck = randomizers.deck.deal(coinFlipWinnerConfig.challengeDeckID)

        let players = playerConfigs.map { playerConfig in
            Player(
                id: playerConfig.id,
                spec: playerConfig.specID.spec,
                state: .inReserves,
                canTakeActions: true
            )
        }.toSet()

        var coinFlipLoserHand = [ChallengeCard]()
        var coinFlipWinnerHand = [ChallengeCard]()

        if let rawTalentBonusRecipientID = coinFlipWinnerConfig.rawTalentBonusRecipientID {
            let card = ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent)
            if rawTalentBonusRecipientID == coinFlipWinnerCoachID {
                coinFlipWinnerHand.append(card)
            } else {
                coinFlipLoserHand.append(card)
            }
        }

        events.append(
            .tableWasSetUp(
                playerConfigs: playerConfigs,
                deck: deck,
                coinFlipLoserHand: coinFlipLoserHand,
                coinFlipWinnerHand: coinFlipWinnerHand
            )
        )

        var objectives = Objectives()
        for newObjectiveID in objectives.deal(from: &deck) {
            events.append(.dealtNewObjective(objectiveID: newObjectiveID))
        }

        table = Table(
            config: FinalizedConfig(
                coinFlipWinnerCoachID: coinFlipWinnerCoachID,
                coinFlipWinnerConfig: coinFlipWinnerConfig,
                coinFlipLoserConfig: coinFlipLoserConfig
            ),
            players: players,
            coinFlipLoserHand: coinFlipLoserHand,
            coinFlipWinnerHand: coinFlipWinnerHand,
            coinFlipLoserActiveBonuses: [],
            coinFlipWinnerActiveBonuses: [],
            coinFlipLoserScore: 0,
            coinFlipWinnerScore: 0,
            balls: [],
            deck: deck,
            objectives: objectives,
            discards: []
        )

        return nil
    }
}
