//
//  SquareTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Testing
@testable import AvalonThree

struct SquareDirectionTests {

    @Test func testValidInDirectionNorth() async throws {
        #expect(sq(3, 3).inDirection(.north) == sq(3, 2))
    }

    @Test func testInvalidInDirectionNorth() async throws {
        #expect(sq(3, 0).inDirection(.north) == nil)
    }

    @Test func testValidInDirectionNorthEast() async throws {
        #expect(sq(3, 3).inDirection(.northEast) == sq(4, 2))
    }

    @Test func testInvalidInDirectionNorthEast() async throws {
        #expect(sq(3, 0).inDirection(.northEast) == nil)
        #expect(sq(10, 3).inDirection(.northEast) == nil)
    }

    @Test func testValidInDirectionEast() async throws {
        #expect(sq(3, 3).inDirection(.east) == sq(4, 3))
    }

    @Test func testInvalidInDirectionEast() async throws {
        #expect(sq(10, 3).inDirection(.east) == nil)
    }

    @Test func testValidInDirectionSouthEast() async throws {
        #expect(sq(3, 3).inDirection(.southEast) == sq(4, 4))
    }

    @Test func testInvalidInDirectionSouthEast() async throws {
        #expect(sq(3, 14).inDirection(.southEast) == nil)
        #expect(sq(10, 3).inDirection(.southEast) == nil)
    }

    @Test func testValidInDirectionSouth() async throws {
        #expect(sq(3, 3).inDirection(.south) == sq(3, 4))
    }

    @Test func testInvalidInDirectionSouth() async throws {
        #expect(sq(3, 14).inDirection(.south) == nil)
    }

    @Test func testValidInDirectionSouthWest() async throws {
        #expect(sq(3, 3).inDirection(.southWest) == sq(2, 4))
    }

    @Test func testInvalidInDirectionSouthWest() async throws {
        #expect(sq(0, 3).inDirection(.southWest) == nil)
        #expect(sq(3, 14).inDirection(.southWest) == nil)
    }

    @Test func testValidInDirectionWest() async throws {
        #expect(sq(3, 3).inDirection(.west) == sq(2, 3))
    }

    @Test func testInvalidInDirectionWest() async throws {
        #expect(sq(0, 3).inDirection(.west) == nil)
    }

    @Test func testValidInDirectionNorthWest() async throws {
        #expect(sq(3, 3).inDirection(.northWest) == sq(2, 2))
    }

    @Test func testInvalidInDirectionNorthWest() async throws {
        #expect(sq(0, 3).inDirection(.northWest) == nil)
        #expect(sq(3, 0).inDirection(.northWest) == nil)
    }

    @Test func testInvalidDirectionToEqual() async throws {
        #expect(sq(5, 5).directionTo(sq(5, 5)) == nil)
    }

    @Test func testInvalidDirectionToNotAdjacent() async throws {
        #expect(sq(5, 5).directionTo(sq(5, 7)) == nil)
    }

    @Test func testValidDirectionToNorth() async throws {
        #expect(sq(5, 5).directionTo(sq(5, 4)) == .north)
    }

    @Test func testValidDirectionToNorthEast() async throws {
        #expect(sq(5, 5).directionTo(sq(6, 4)) == .northEast)
    }

    @Test func testValidDirectionToEast() async throws {
        #expect(sq(5, 5).directionTo(sq(6, 5)) == .east)
    }

    @Test func testValidDirectionToSouthEast() async throws {
        #expect(sq(5, 5).directionTo(sq(6, 6)) == .southEast)
    }

    @Test func testValidDirectionToSouth() async throws {
        #expect(sq(5, 5).directionTo(sq(5, 6)) == .south)
    }

    @Test func testValidDirectionToSouthWest() async throws {
        #expect(sq(5, 5).directionTo(sq(4, 6)) == .southWest)
    }

    @Test func testValidDirectionToWest() async throws {
        #expect(sq(5, 5).directionTo(sq(4, 5)) == .west)
    }

    @Test func testValidDirectionToNorthWest() async throws {
        #expect(sq(5, 5).directionTo(sq(4, 4)) == .northWest)
    }
}
