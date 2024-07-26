//
//  Square+PathTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Testing
@testable import AvalonThree

struct SquarePathTests {

    @Test func testNoPathWhenASquareIsImpassable() async throws {
        let path = try Square.optimalPath(
            from: sq(3, 3),
            to: sq(3, 4),
            isValid: { square, _ in
                square != sq(3, 4)
            }
        )
        #expect(path == nil)
    }

    @Test func testNoPathWhenFinalSquareIsImpassable() async throws {
        let path = try Square.optimalPath(
            from: sq(3, 3),
            to: sq(3, 5),
            isValid: { _, isFinalSquare in
                !isFinalSquare
            }
        )
        #expect(path == nil)
    }

    @Test func testPathToSelf() async throws {
        let path = try Square.optimalPath(
            from: sq(5, 5),
            to: sq(5, 5),
            isValid: { _, _ in
                true
            }
        )
        #expect(path == [])
    }

    @Test func testEasyPath() async throws {
        let path = try Square.optimalPath(
            from: sq(3, 3),
            to: sq(5, 5),
            isValid: { _, _ in
                true
            }
        )
        #expect(path == [sq(4, 4), sq(5, 5)])
    }

    @Test func testHardPath() async throws {
        let impassable = Set<Square>(
            [
                sq(3, 3),
                sq(4, 3),
                sq(5, 3),
                sq(3, 4),
                sq(3, 5),
                sq(3, 6),
            ]
        )
        let path = try Square.optimalPath(
            from: sq(0, 0),
            to: sq(4, 4),
            isValid: { square, _ in
                !impassable.contains(square)
            }
        )
        #expect(path == [sq(1, 1), sq(2, 2), sq(3, 2), sq(4, 2), sq(5, 2), sq(6, 3), sq(5, 4), sq(4, 4)])
    }

    @Test func testImpossiblePath() async throws {
        let path = try Square.optimalPath(
            from: sq(0, 0),
            to: sq(8, 0),
            isValid: { square, _ in
                square.x != 5
            }
        )
        #expect(path == nil)
    }
}
