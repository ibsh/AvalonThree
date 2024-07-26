//
//  SquareTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Testing
@testable import AvalonThree

struct SquareTests {

    @Test func testNaiveDistanceCardinals() async throws {
        #expect(sq(5, 8).naiveDistance(to: sq(5, 3)) == 5)
        #expect(sq(5, 8).naiveDistance(to: sq(8, 8)) == 3)
        #expect(sq(5, 8).naiveDistance(to: sq(9, 8)) == 4)
        #expect(sq(5, 8).naiveDistance(to: sq(5, 14)) == 6)
    }

    @Test func testNaiveDistanceElsewhere() async throws {
        #expect(sq(5, 8).naiveDistance(to: sq(7, 5)) == 3)
        #expect(sq(5, 8).naiveDistance(to: sq(7, 13)) == 5)
        #expect(sq(5, 8).naiveDistance(to: sq(2, 12)) == 4)
        #expect(sq(5, 8).naiveDistance(to: sq(0, 1)) == 7)
    }

    @Test func testIsAdjacent() async throws {
        #expect(sq(5, 8).isAdjacent(to: sq(5, 7)))
        #expect(sq(5, 8).isAdjacent(to: sq(6, 7)))
        #expect(sq(5, 8).isAdjacent(to: sq(6, 8)))
        #expect(sq(5, 8).isAdjacent(to: sq(6, 9)))
        #expect(sq(5, 8).isAdjacent(to: sq(5, 9)))
        #expect(sq(5, 8).isAdjacent(to: sq(4, 9)))
        #expect(sq(5, 8).isAdjacent(to: sq(4, 8)))
        #expect(sq(5, 8).isAdjacent(to: sq(4, 7)))
        #expect(sq(5, 8).isAdjacent(to: sq(3, 8)) == false)
        #expect(sq(5, 8).isAdjacent(to: sq(7, 8)) == false)
        #expect(sq(5, 8).isAdjacent(to: sq(5, 6)) == false)
        #expect(sq(5, 8).isAdjacent(to: sq(5, 10)) == false)
    }

    @Test func testAdjacentSquaresInTheMiddle() async throws {
        #expect(
            sq(5, 8).adjacentSquares == [
                sq(5, 8),
                sq(4, 7),
                sq(5, 7),
                sq(6, 7),
                sq(4, 8),
                sq(6, 8),
                sq(4, 9),
                sq(5, 9),
                sq(6, 9),
            ]
        )
        #expect(
            sq(2, 6).adjacentSquares == [
                sq(2, 6),
                sq(1, 5),
                sq(2, 5),
                sq(3, 5),
                sq(1, 6),
                sq(3, 6),
                sq(1, 7),
                sq(2, 7),
                sq(3, 7),
            ]
        )
        #expect(
            sq(1, 13).adjacentSquares == [
                sq(1, 13),
                sq(0, 12),
                sq(1, 12),
                sq(2, 12),
                sq(0, 13),
                sq(2, 13),
                sq(0, 14),
                sq(1, 14),
                sq(2, 14),
            ]
        )
        #expect(
            sq(9, 10).adjacentSquares == [
                sq(9, 10),
                sq(8, 9),
                sq(9, 9),
                sq(10, 9),
                sq(8, 10),
                sq(10, 10),
                sq(8, 11),
                sq(9, 11),
                sq(10, 11),
            ]
        )
    }

    @Test func testAdjacentSquaresOnTheEdges() async throws {
        #expect(
            sq(4, 0).adjacentSquares == [
                sq(4, 0),
                sq(3, 0),
                sq(5, 0),
                sq(3, 1),
                sq(4, 1),
                sq(5, 1),
            ]
        )
        #expect(
            sq(10, 7).adjacentSquares == [
                sq(10, 7),
                sq(9, 6),
                sq(10, 6),
                sq(9, 7),
                sq(9, 8),
                sq(10, 8),
            ]
        )
        #expect(
            sq(4, 14).adjacentSquares == [
                sq(4, 14),
                sq(3, 13),
                sq(4, 13),
                sq(5, 13),
                sq(3, 14),
                sq(5, 14),
            ]
        )
        #expect(
            sq(0, 7).adjacentSquares == [
                sq(0, 7),
                sq(0, 6),
                sq(1, 6),
                sq(1, 7),
                sq(0, 8),
                sq(1, 8),
            ]
        )
    }

    @Test func testAdjacentSquaresInTheCorners() async throws {
        #expect(
            sq(10, 0).adjacentSquares == [
                sq(10, 0),
                sq(9, 0),
                sq(9, 1),
                sq(10, 1),
            ]
        )
        #expect(
            sq(10, 14).adjacentSquares == [
                sq(10, 14),
                sq(9, 13),
                sq(10, 13),
                sq(9, 14),
            ]
        )
        #expect(
            sq(0, 14).adjacentSquares == [
                sq(0, 14),
                sq(0, 13),
                sq(1, 13),
                sq(1, 14),
            ]
        )
        #expect(
            sq(0, 0).adjacentSquares == [
                sq(0, 0),
                sq(1, 0),
                sq(0, 1),
                sq(1, 1),
            ]
        )
    }

    @Test func testNaiveNeighbourhood() async throws {
        #expect(
            sq(5, 8).naiveNeighbourhood(distance: 3) == [
                sq(5, 8), // naive distance 0
                sq(4, 7), // 1
                sq(5, 7), // 1
                sq(6, 7), // 1
                sq(4, 8), // 1
                sq(6, 8), // 1
                sq(4, 9), // 1
                sq(5, 9), // 1
                sq(6, 9), // 1
                sq(3, 6), // 2
                sq(4, 6), // 2
                sq(5, 6), // 2
                sq(6, 6), // 2
                sq(7, 6), // 2
                sq(3, 7), // 2
                sq(7, 7), // 2
                sq(3, 8), // 2
                sq(7, 8), // 2
                sq(3, 9), // 2
                sq(7, 9), // 2
                sq(3, 10), // 2
                sq(4, 10), // 2
                sq(5, 10), // 2
                sq(6, 10), // 2
                sq(7, 10), // 2
                sq(2, 5), // 3
                sq(3, 5), // 3
                sq(4, 5), // 3
                sq(5, 5), // 3
                sq(6, 5), // 3
                sq(7, 5), // 3
                sq(8, 5), // 3
                sq(2, 6), // 3
                sq(8, 6), // 3
                sq(2, 7), // 3
                sq(8, 7), // 3
                sq(2, 8), // 3
                sq(8, 8), // 3
                sq(2, 9), // 3
                sq(8, 9), // 3
                sq(2, 10), // 3
                sq(8, 10), // 3
                sq(2, 11), // 3
                sq(3, 11), // 3
                sq(4, 11), // 3
                sq(5, 11), // 3
                sq(6, 11), // 3
                sq(7, 11), // 3
                sq(8, 11), // 3
            ]
        )
    }
}
