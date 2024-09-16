//
//  Square+CoachTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/16/24.
//

import Testing
@testable import AvalonThree

struct SquareCoachTests {

    @Test func testEndZoneAwayCoach() async throws {
        #expect(
            Square.endZoneSquares(coachID: .away) == [
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

    @Test func testEndZoneHomeCoach() async throws {
        #expect(
            Square.endZoneSquares(coachID: .home) == [
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
