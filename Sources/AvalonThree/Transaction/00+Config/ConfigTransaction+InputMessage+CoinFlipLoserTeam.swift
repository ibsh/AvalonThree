//
//  ConfigTransaction+InputMessage+CoinFlipLoserTeam.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func specifyCoinFlipLoserTeam(
        teamID coinFlipLoserTeamID: TeamID
    ) throws -> Prompt? {

        guard let coinFlipWinnerCoachID = config.coinFlipWinnerCoachID else {
            throw GameError("Coin has not been flipped yet")
        }

        guard let boardSpecID = config.boardSpecID else {
            throw GameError("Board spec has not been specified yet")
        }

        guard let challengeDeckID = config.challengeDeckID else {
            throw GameError("Challenge deck has not been specified yet")
        }

        guard let rookieBonusRecipientID = config.rookieBonusRecipientID else {
            throw GameError("Raw Talent bonus play recipient has not been specified yet")
        }

        guard let coinFlipWinnerTeamID = config.coinFlipWinnerTeamID else {
            throw GameError("Coin flip winner team has not been specified yet")
        }

        guard config.coinFlipLoserTeamID == nil else {
            throw GameError("Coin flip loser team has already been specified")
        }

        guard TeamID.availableCases.contains(coinFlipLoserTeamID) else {
            throw GameError("Invalid coin flip loser team choice")
        }

        events.append(.specifiedCoinFlipLoserTeam(teamID: coinFlipLoserTeamID))

        config.coinFlipLoserTeamID = coinFlipLoserTeamID

        let coinFlipLoserPlayerConfigs = coinFlipLoserTeamID.spec
            .playerConfigs(coachID: coinFlipWinnerCoachID.inverse)

        let coinFlipWinnerPlayerConfigs = coinFlipWinnerTeamID.spec
            .playerConfigs(coachID: coinFlipWinnerCoachID)

        let playerConfigs = coinFlipLoserPlayerConfigs.union(coinFlipWinnerPlayerConfigs)

        var deck = randomizers.deck.deal(challengeDeckID)

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

        let rawTalentBonusPlay = ChallengeCard(challenge: .breakSomeBones, bonusPlay: .rawTalent)
        switch rookieBonusRecipientID {
        case .noOne:
            break
        case .coinFlipLoser:
            coinFlipLoserHand.append(rawTalentBonusPlay)
        case .coinFlipWinner:
            coinFlipWinnerHand.append(rawTalentBonusPlay)
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
                boardSpecID: boardSpecID,
                challengeDeckID: challengeDeckID,
                rookieBonusRecipientID: rookieBonusRecipientID,
                coinFlipWinnerTeamID: coinFlipWinnerTeamID,
                coinFlipLoserTeamID: coinFlipLoserTeamID
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
