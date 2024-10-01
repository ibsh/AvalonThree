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

        let coinFlipLoserCoachID = coinFlipWinnerCoachID.inverse

        events.append(
            .specifiedTeam(coachID: coinFlipLoserCoachID, teamID: coinFlipLoserTeamID)
        )

        config.coinFlipLoserTeamID = coinFlipLoserTeamID

        var coinFlipLoserHand = [ChallengeCard]()
        var coinFlipWinnerHand = [ChallengeCard]()

        let rookieBonusCard = ChallengeCard(challenge: .rookieBonus, bonusPlay: .rawTalent)
        switch rookieBonusRecipientID {
        case .noOne:
            break
        case .coinFlipLoser:
            coinFlipLoserHand.append(rookieBonusCard)
        case .coinFlipWinner:
            coinFlipWinnerHand.append(rookieBonusCard)
        }

        events.append(
            .startingHandWasSetUp(
                coachID: coinFlipWinnerCoachID,
                hand: coinFlipWinnerHand.map { .open(card: $0) }
            )
        )
        events.append(
            .startingHandWasSetUp(
                coachID: coinFlipLoserCoachID,
                hand: coinFlipLoserHand.map { .open(card: $0) }
            )
        )

        let coinFlipLoserPlayerSetups = coinFlipLoserTeamID.spec
            .playerSetups(coachID: coinFlipWinnerCoachID.inverse)

        let coinFlipWinnerPlayerSetups = coinFlipWinnerTeamID.spec
            .playerSetups(coachID: coinFlipWinnerCoachID)

        let playerSetups = coinFlipLoserPlayerSetups + coinFlipWinnerPlayerSetups

        var deck = randomizers.deck.deal(challengeDeckID)

        let players = playerSetups.map { playerSetup in
            Player(
                id: playerSetup.id,
                spec: playerSetup.specID.spec,
                state: .inReserves,
                canTakeActions: true
            )
        }

        var playerNumberData = randomizers.playerNumber.getPlayerNumbers(count: players.count)

        let playerNumbers: [PlayerID: Int] = players.reduce([:]) { partialResult, player in
            let number = playerNumberData.removeFirst()
            events.append(
                .playerReceivedNumber(playerID: player.id, number: number)
            )
            return partialResult.adding(
                key: player.id,
                value: number
            )
        }

        events.append(
            .startingPlayersWereSetUp(
                coachID: coinFlipWinnerCoachID,
                playerSetups: playerSetups.filter { $0.id.coachID == coinFlipWinnerCoachID }
            )
        )
        events.append(
            .startingPlayersWereSetUp(
                coachID: coinFlipLoserCoachID,
                playerSetups: playerSetups.filter { $0.id.coachID == coinFlipLoserCoachID }
            )
        )

        events.append(
            .updatedDeck(top: deck.first?.challenge, count: deck.count)
        )

        var objectives = Objectives()

        if objectives.first == nil, let card = deck.popFirst() {
            objectives.first = card
            events.append(
                .dealtNewObjective(
                    coachID: coinFlipWinnerCoachID.inverse,
                    objectiveID: .first,
                    objective: card.challenge
                )
            )
            events.append(
                .updatedDeck(top: deck.first?.challenge, count: deck.count)
            )
        }

        if objectives.second == nil, let card = deck.popFirst() {
            objectives.second = card
            events.append(
                .dealtNewObjective(
                    coachID: coinFlipWinnerCoachID.inverse,
                    objectiveID: .second,
                    objective: card.challenge
                )
            )
            events.append(
                .updatedDeck(top: deck.first?.challenge, count: deck.count)
            )
        }

        if objectives.third == nil, let card = deck.popFirst() {
            objectives.third = card
            events.append(
                .dealtNewObjective(
                    coachID: coinFlipWinnerCoachID.inverse,
                    objectiveID: .third,
                    objective: card.challenge
                )
            )
            events.append(
                .updatedDeck(top: deck.first?.challenge, count: deck.count)
            )
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
            players: players.toSet(),
            playerNumbers: playerNumbers,
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
