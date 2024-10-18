//
//  ConfigTransaction+InputMessage+SelectTeam.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/17/24.
//

import Foundation

extension ConfigTransaction {

    mutating func selectTeam(
        coachID: CoachID,
        teamID: TeamID
    ) throws -> AddressedPrompt? {

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

        if coachID == coinFlipWinnerCoachID {

            guard config.coinFlipWinnerTeamID == nil else {
                throw GameError("Coin flip winner team has already been specified")
            }

            guard TeamID.availableCases.contains(teamID) else {
                throw GameError("Invalid coin flip winner team choice")
            }

            events.append(
                .specifiedTeam(coachID: coinFlipWinnerCoachID, teamID: teamID)
            )

            config.coinFlipWinnerTeamID = teamID

            return AddressedPrompt(
                coachID: coinFlipWinnerCoachID.inverse,
                prompt: .selectTeam(
                    teamIDs: TeamID.availableCases
                )
            )
        }

        guard let coinFlipWinnerTeamID = config.coinFlipWinnerTeamID else {
            throw GameError("Coin flip winner team has not been specified yet")
        }

        guard config.coinFlipLoserTeamID == nil else {
            throw GameError("Coin flip loser team has already been specified")
        }

        guard TeamID.availableCases.contains(teamID) else {
            throw GameError("Invalid coin flip loser team choice")
        }

        let coinFlipLoserCoachID = coinFlipWinnerCoachID.inverse

        events.append(
            .specifiedTeam(coachID: coinFlipLoserCoachID, teamID: teamID)
        )

        config.coinFlipLoserTeamID = teamID

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

        let coinFlipLoserPlayerSetups = teamID.spec
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

        var playerNumberSet = Set<Int>()

        let playerNumbers: [PlayerID: Int] = players.reduce([:]) { partialResult, player in
            let playerNumber: Int = {
                var entry: Int
                while true {
                    entry = randomizers.playerNumber.generate()
                    if playerNumberSet.insert(entry).inserted { break }
                }
                return entry
            }()

            events.append(
                .playerReceivedNumber(playerID: player.id, number: playerNumber)
            )
            return partialResult.adding(
                key: player.id,
                value: playerNumber
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
            .updatedDeck(
                top: deck.first?.toWrappedObjective(),
                count: deck.count
            )
        )

        var objectives = Objectives()

        if objectives.first == nil, let card = deck.popFirst() {
            objectives.first = card
            events.append(
                .dealtNewObjective(
                    coachID: coinFlipWinnerCoachID.inverse,
                    objectiveIndex: 0,
                    objectives: objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDeck(
                    top: deck.first?.toWrappedObjective(),
                    count: deck.count
                )
            )
        }

        if objectives.second == nil, let card = deck.popFirst() {
            objectives.second = card
            events.append(
                .dealtNewObjective(
                    coachID: coinFlipWinnerCoachID.inverse,
                    objectiveIndex: 1,
                    objectives: objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDeck(
                    top: deck.first?.toWrappedObjective(),
                    count: deck.count
                )
            )
        }

        if objectives.third == nil, let card = deck.popFirst() {
            objectives.third = card
            events.append(
                .dealtNewObjective(
                    coachID: coinFlipWinnerCoachID.inverse,
                    objectiveIndex: 2,
                    objectives: objectives.toWrappedObjectives()
                )
            )
            events.append(
                .updatedDeck(
                    top: deck.first?.toWrappedObjective(),
                    count: deck.count
                )
            )
        }

        table = Table(
            config: FinalizedConfig(
                coinFlipWinnerCoachID: coinFlipWinnerCoachID,
                boardSpecID: boardSpecID,
                challengeDeckID: challengeDeckID,
                rookieBonusRecipientID: rookieBonusRecipientID,
                coinFlipWinnerTeamID: coinFlipWinnerTeamID,
                coinFlipLoserTeamID: teamID
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
