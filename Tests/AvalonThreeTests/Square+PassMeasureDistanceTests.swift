//
//  Square+PassMeasureDistanceTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Testing
@testable import AvalonThree

struct SquarePassMeasureDistanceTests {

    // Diagram from rulebook is as follows:

    // P H S S S L L L L
    // H H S S S L L L L
    // S S S S S L L L L
    // S S S S L L L L L
    // S S S L L L L L
    // L L L L L L L L
    // L L L L L L L
    // L L L L L L
    // L L L L

    @Test func testFirstRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 0), hailMaryPass: false) == nil)
        #expect(sq(0, 0).measurePass(to: sq(1, 0), hailMaryPass: false)!.distance == .handoff)
        #expect(sq(0, 0).measurePass(to: sq(2, 0), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(3, 0), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(4, 0), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(5, 0), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 0), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 0), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(8, 0), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(9, 0), hailMaryPass: false) == nil)
    }

    @Test func testSecondRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 1), hailMaryPass: false)!.distance == .handoff)
        #expect(sq(0, 0).measurePass(to: sq(1, 1), hailMaryPass: false)!.distance == .handoff)
        #expect(sq(0, 0).measurePass(to: sq(2, 1), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(3, 1), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(4, 1), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(5, 1), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 1), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 1), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(8, 1), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(9, 1), hailMaryPass: false) == nil)
    }

    @Test func testThirdRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 2), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(1, 2), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(2, 2), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(3, 2), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(4, 2), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(5, 2), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 2), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 2), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(8, 2), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(9, 2), hailMaryPass: false) == nil)
    }

    @Test func testFourthRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 3), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(1, 3), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(2, 3), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(3, 3), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(4, 3), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(5, 3), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 3), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 3), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(8, 3), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(9, 3), hailMaryPass: false) == nil)
    }

    @Test func testFifthRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 4), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(1, 4), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(2, 4), hailMaryPass: false)!.distance == .short)
        #expect(sq(0, 0).measurePass(to: sq(3, 4), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(4, 4), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(5, 4), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 4), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 4), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(8, 4), hailMaryPass: false) == nil)
    }

    @Test func testSixthRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(1, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(2, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(3, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(4, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(5, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 5), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(8, 5), hailMaryPass: false) == nil)
    }

    @Test func testSeventhRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(1, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(2, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(3, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(4, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(5, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 6), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(7, 6), hailMaryPass: false) == nil)
    }

    @Test func testEighthRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 7), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(1, 7), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(2, 7), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(3, 7), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(4, 7), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(5, 7), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(6, 7), hailMaryPass: false) == nil)
    }

    @Test func testNinthRowOfDiagram() async throws {
        #expect(sq(0, 0).measurePass(to: sq(0, 8), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(1, 8), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(2, 8), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(3, 8), hailMaryPass: false)!.distance == .long)
        #expect(sq(0, 0).measurePass(to: sq(4, 8), hailMaryPass: false) == nil)
    }
}
