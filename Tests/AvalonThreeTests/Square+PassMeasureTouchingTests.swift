//
//  Square+PassMeasureTouchingTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Testing
@testable import AvalonThree

struct SquarePassMeasureTouchingTests {

    // Diagram from rulebook is essentially as follows:

    // P H S S S L L L L
    // H H S S S L L L L
    //     S S S L L L L
    //       S L L L L L
    //         L L L L
    //           L L L
    //             L

    // All the touched squares were measured and double checked using a real board and ruler.

    @Test func testHandoffs() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(1, 0), hailMaryPass: false)!.touchingSquares == []
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(1, 1), hailMaryPass: false)!.touchingSquares == []
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(0, 1), hailMaryPass: false)!.touchingSquares == []
        )
    }

    @Test func testFirstRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(2, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(3, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(4, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(5, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(7, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                    sq(6, 0),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(8, 0), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                    sq(6, 0),
                    sq(7, 0),
                ]
        )
    }

    @Test func testSecondRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(2, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(3, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(4, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(5, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                    sq(6, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(7, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                    sq(6, 0),
                    sq(7, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(6, 1),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(8, 1), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(5, 0),
                    sq(6, 0),
                    sq(7, 0),
                    sq(8, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(6, 1),
                    sq(7, 1),
                ]
        )
    }

    @Test func testThirdRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(2, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(1, 2),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(3, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(1, 2),
                    sq(2, 2),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(4, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(2, 2),
                    sq(3, 2),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(5, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(6, 1),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(7, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(6, 1),
                    sq(7, 1),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(6, 2),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(8, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(4, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(6, 1),
                    sq(7, 1),
                    sq(8, 1),
                    sq(4, 2),
                    sq(5, 2),
                    sq(6, 2),
                    sq(7, 2),
                ]
        )
    }

    @Test func testFourthRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(3, 3), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(2, 3),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(4, 3), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(3, 3),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(5, 3), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(2, 2),
                    sq(3, 3),
                    sq(4, 3),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 3), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(6, 2),
                    sq(4, 3),
                    sq(5, 3),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(7, 3), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(6, 2),
                    sq(7, 2),
                    sq(5, 3),
                    sq(6, 3),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(8, 3), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(3, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(5, 1),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(6, 2),
                    sq(7, 2),
                    sq(8, 2),
                    sq(5, 3),
                    sq(6, 3),
                    sq(7, 3),
                ]
        )
    }

    @Test func testFifthRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(4, 4), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(2, 3),
                    sq(3, 3),
                    sq(4, 3),
                    sq(3, 4),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(5, 4), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(2, 3),
                    sq(3, 3),
                    sq(4, 3),
                    sq(5, 3),
                    sq(4, 4),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 4), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(3, 3),
                    sq(4, 3),
                    sq(5, 3),
                    sq(6, 3),
                    sq(4, 4),
                    sq(5, 4),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(7, 4), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(4, 1),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(5, 2),
                    sq(3, 3),
                    sq(4, 3),
                    sq(5, 3),
                    sq(6, 3),
                    sq(7, 3),
                    sq(5, 4),
                    sq(6, 4),
                ]
        )
    }

    @Test func testSixthRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(5, 5), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(2, 3),
                    sq(3, 3),
                    sq(4, 3),
                    sq(3, 4),
                    sq(4, 4),
                    sq(5, 4),
                    sq(4, 5),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 5), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(2, 3),
                    sq(3, 3),
                    sq(4, 3),
                    sq(5, 3),
                    sq(3, 4),
                    sq(4, 4),
                    sq(5, 4),
                    sq(6, 4),
                    sq(5, 5),
                ]
        )
        #expect(
            sq(0, 0)
                .measurePass(to: sq(7, 5), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(2, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(3, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(4, 2),
                    sq(3, 3),
                    sq(4, 3),
                    sq(5, 3),
                    sq(6, 3),
                    sq(4, 4),
                    sq(5, 4),
                    sq(6, 4),
                    sq(7, 4),
                    sq(5, 5),
                    sq(6, 5),
                ]
        )
    }

    @Test func testSeventhRowOfDiagram() async throws {
        #expect(
            sq(0, 0)
                .measurePass(to: sq(6, 6), hailMaryPass: false)!.touchingSquares == [
                    sq(1, 0),
                    sq(0, 1),
                    sq(1, 1),
                    sq(2, 1),
                    sq(1, 2),
                    sq(2, 2),
                    sq(3, 2),
                    sq(2, 3),
                    sq(3, 3),
                    sq(4, 3),
                    sq(3, 4),
                    sq(4, 4),
                    sq(5, 4),
                    sq(4, 5),
                    sq(5, 5),
                    sq(6, 5),
                    sq(5, 6),
                ]
        )
    }

    @Test func testMathWorksInSixteenDirections() async throws {
        // N
        #expect(
            sq(6, 6)
                .measurePass(to: sq(6, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(6, 3),
                    sq(6, 4),
                    sq(6, 5),
                ]
        )
        // NNEish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(8, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(7, 2),
                    sq(7, 3),
                    sq(8, 3),
                    sq(6, 4),
                    sq(7, 4),
                    sq(8, 4),
                    sq(6, 5),
                    sq(7, 5),
                    sq(7, 6),
                ]
        )
        // NE
        #expect(
            sq(6, 6)
                .measurePass(to: sq(10, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(9, 2),
                    sq(8, 3),
                    sq(9, 3),
                    sq(10, 3),
                    sq(7, 4),
                    sq(8, 4),
                    sq(9, 4),
                    sq(6, 5),
                    sq(7, 5),
                    sq(8, 5),
                    sq(7, 6),
                ]
        )
        // ENEish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(10, 4), hailMaryPass: false)!.touchingSquares == [
                    sq(8, 4),
                    sq(9, 4),
                    sq(6, 5),
                    sq(7, 5),
                    sq(8, 5),
                    sq(9, 5),
                    sq(10, 5),
                    sq(7, 6),
                    sq(8, 6),
                ]
        )
        // E
        #expect(
            sq(6, 6)
                .measurePass(to: sq(10, 6), hailMaryPass: false)!.touchingSquares == [
                    sq(7, 6),
                    sq(8, 6),
                    sq(9, 6),
                ]
        )
        // ESEish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(10, 8), hailMaryPass: false)!.touchingSquares == [
                    sq(7, 6),
                    sq(8, 6),
                    sq(6, 7),
                    sq(7, 7),
                    sq(8, 7),
                    sq(9, 7),
                    sq(10, 7),
                    sq(8, 8),
                    sq(9, 8),
                ]
        )
        // SE
        #expect(
            sq(6, 6)
                .measurePass(to: sq(10, 10), hailMaryPass: false)!.touchingSquares == [
                    sq(7, 6),
                    sq(6, 7),
                    sq(7, 7),
                    sq(8, 7),
                    sq(7, 8),
                    sq(8, 8),
                    sq(9, 8),
                    sq(8, 9),
                    sq(9, 9),
                    sq(10, 9),
                    sq(9, 10),
                ]
        )
        // SSEish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(8, 10), hailMaryPass: false)!.touchingSquares == [
                    sq(7, 6),
                    sq(6, 7),
                    sq(7, 7),
                    sq(6, 8),
                    sq(7, 8),
                    sq(8, 8),
                    sq(7, 9),
                    sq(8, 9),
                    sq(7, 10),
                ]
        )
        // S
        #expect(
            sq(6, 6)
                .measurePass(to: sq(6, 10), hailMaryPass: false)!.touchingSquares == [
                    sq(6, 7),
                    sq(6, 8),
                    sq(6, 9),
                ]
        )
        // SSWish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(4, 10), hailMaryPass: false)!.touchingSquares == [
                    sq(5, 6),
                    sq(5, 7),
                    sq(6, 7),
                    sq(4, 8),
                    sq(5, 8),
                    sq(6, 8),
                    sq(4, 9),
                    sq(5, 9),
                    sq(5, 10),
                ]
        )
        // SW
        #expect(
            sq(6, 6)
                .measurePass(to: sq(2, 10), hailMaryPass: false)!.touchingSquares == [
                    sq(5, 6),
                    sq(4, 7),
                    sq(5, 7),
                    sq(6, 7),
                    sq(3, 8),
                    sq(4, 8),
                    sq(5, 8),
                    sq(2, 9),
                    sq(3, 9),
                    sq(4, 9),
                    sq(3, 10),
                ]
        )
        // WSWish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(2, 8), hailMaryPass: false)!.touchingSquares == [
                    sq(4, 6),
                    sq(5, 6),
                    sq(2, 7),
                    sq(3, 7),
                    sq(4, 7),
                    sq(5, 7),
                    sq(6, 7),
                    sq(3, 8),
                    sq(4, 8),
                ]
        )
        // W
        #expect(
            sq(6, 6)
                .measurePass(to: sq(2, 6), hailMaryPass: false)!.touchingSquares == [
                    sq(3, 6),
                    sq(4, 6),
                    sq(5, 6),
                ]
        )
        // WNWish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(2, 4), hailMaryPass: false)!.touchingSquares == [
                    sq(3, 4),
                    sq(4, 4),
                    sq(2, 5),
                    sq(3, 5),
                    sq(4, 5),
                    sq(5, 5),
                    sq(6, 5),
                    sq(4, 6),
                    sq(5, 6),
                ]
        )
        // NW
        #expect(
            sq(6, 6)
                .measurePass(to: sq(2, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(3, 2),
                    sq(2, 3),
                    sq(3, 3),
                    sq(4, 3),
                    sq(3, 4),
                    sq(4, 4),
                    sq(5, 4),
                    sq(4, 5),
                    sq(5, 5),
                    sq(6, 5),
                    sq(5, 6),
                ]
        )
        // NNWish
        #expect(
            sq(6, 6)
                .measurePass(to: sq(4, 2), hailMaryPass: false)!.touchingSquares == [
                    sq(5, 2),
                    sq(4, 3),
                    sq(5, 3),
                    sq(4, 4),
                    sq(5, 4),
                    sq(6, 4),
                    sq(5, 5),
                    sq(6, 5),
                    sq(5, 6),
                ]
        )
    }
}
