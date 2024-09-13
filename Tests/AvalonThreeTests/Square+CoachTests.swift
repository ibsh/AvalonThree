//
//  Square+CoachTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/16/24.
//

import Testing
@testable import AvalonThree

struct SquareCoachTests {

    private let table = Table(
        config: FinalizedConfig(
            coinFlipWinnerCoachID: .home,
            boardSpecID: .bilbaliHarbor,
            challengeDeckID: .longRandomised,
            rookieBonusRecipientID: .noOne,
            coinFlipWinnerTeamID: .darkElf,
            coinFlipLoserTeamID: .woodElf
        ),
        players: [],
        coinFlipLoserHand: [],
        coinFlipWinnerHand: [],
        coinFlipLoserActiveBonuses: [],
        coinFlipWinnerActiveBonuses: [],
        coinFlipLoserScore: 0,
        coinFlipWinnerScore: 0,
        balls: [],
        deck: [],
        objectives: Objectives(),
        discards: []
    )

    @Test func testEndZoneFirstCoach() async throws {
        #expect(
            table.endZoneSquares(coachID: .away) == [
                sq(0, 0),
                sq(1, 0),
                sq(2, 0),
                sq(3, 0),
                sq(4, 0),
                sq(5, 0),
                sq(6, 0),
                sq(7, 0),
                sq(8, 0),
                sq(9, 0),
                sq(10, 0),
            ]
        )
    }

    @Test func testEndZoneSecondCoach() async throws {
        #expect(
            table.endZoneSquares(coachID: .home) == [
                sq(0, 14),
                sq(1, 14),
                sq(2, 14),
                sq(3, 14),
                sq(4, 14),
                sq(5, 14),
                sq(6, 14),
                sq(7, 14),
                sq(8, 14),
                sq(9, 14),
                sq(10, 14),
            ]
        )
    }
}
