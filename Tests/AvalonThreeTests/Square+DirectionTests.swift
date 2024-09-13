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
        #expect(sq(5, 5).direction(to: sq(5, 5)) == nil)
    }

    @Test func testInvalidDirectionToNotAdjacent() async throws {
        #expect(sq(5, 5).direction(to: sq(5, 7)) == nil)
    }

    @Test func testValidDirectionToNorth() async throws {
        #expect(sq(5, 5).direction(to: sq(5, 4)) == .north)
    }

    @Test func testValidDirectionToNorthEast() async throws {
        #expect(sq(5, 5).direction(to: sq(6, 4)) == .northEast)
    }

    @Test func testValidDirectionToEast() async throws {
        #expect(sq(5, 5).direction(to: sq(6, 5)) == .east)
    }

    @Test func testValidDirectionToSouthEast() async throws {
        #expect(sq(5, 5).direction(to: sq(6, 6)) == .southEast)
    }

    @Test func testValidDirectionToSouth() async throws {
        #expect(sq(5, 5).direction(to: sq(5, 6)) == .south)
    }

    @Test func testValidDirectionToSouthWest() async throws {
        #expect(sq(5, 5).direction(to: sq(4, 6)) == .southWest)
    }

    @Test func testValidDirectionToWest() async throws {
        #expect(sq(5, 5).direction(to: sq(4, 5)) == .west)
    }

    @Test func testValidDirectionToNorthWest() async throws {
        #expect(sq(5, 5).direction(to: sq(4, 4)) == .northWest)
    }

    @Test func testInvalidVisualDirectionToEqual() async throws {
        #expect(sq(5, 5).visualDirection(to: sq(5, 5)) == nil)
    }

    @Test func testValidVisualDirectionToAdjacent() async throws {
        #expect(sq(5, 5).visualDirection(to: sq(5, 4)) == .north)
        #expect(sq(5, 5).visualDirection(to: sq(6, 4)) == .northEast)
        #expect(sq(5, 5).visualDirection(to: sq(6, 5)) == .east)
        #expect(sq(5, 5).visualDirection(to: sq(6, 6)) == .southEast)
        #expect(sq(5, 5).visualDirection(to: sq(5, 6)) == .south)
        #expect(sq(5, 5).visualDirection(to: sq(4, 6)) == .southWest)
        #expect(sq(5, 5).visualDirection(to: sq(4, 5)) == .west)
        #expect(sq(5, 5).visualDirection(to: sq(4, 4)) == .northWest)
    }

    @Test func testValidVisualDirectionToDistant() async throws {
        #expect(sq(5, 5).visualDirection(to: sq(5, 0)) == .north)
        #expect(sq(5, 5).visualDirection(to: sq(6, 0)) == .north)
        #expect(sq(5, 5).visualDirection(to: sq(7, 0)) == .north)
        #expect(sq(5, 5).visualDirection(to: sq(8, 0)) == .northEast)
        #expect(sq(5, 5).visualDirection(to: sq(9, 0)) == .northEast)
        #expect(sq(5, 5).visualDirection(to: sq(10, 0)) == .northEast)
        #expect(sq(5, 5).visualDirection(to: sq(10, 1)) == .northEast)
        #expect(sq(5, 5).visualDirection(to: sq(10, 2)) == .northEast)
        #expect(sq(5, 5).visualDirection(to: sq(10, 3)) == .east)
        #expect(sq(5, 5).visualDirection(to: sq(10, 4)) == .east)
        #expect(sq(5, 5).visualDirection(to: sq(10, 5)) == .east)
        #expect(sq(5, 5).visualDirection(to: sq(10, 6)) == .east)
        #expect(sq(5, 5).visualDirection(to: sq(10, 7)) == .east)
        #expect(sq(5, 5).visualDirection(to: sq(10, 8)) == .southEast)
        #expect(sq(5, 5).visualDirection(to: sq(10, 9)) == .southEast)
        #expect(sq(5, 5).visualDirection(to: sq(10, 10)) == .southEast)
        #expect(sq(5, 5).visualDirection(to: sq(9, 10)) == .southEast)
        #expect(sq(5, 5).visualDirection(to: sq(8, 10)) == .southEast)
        #expect(sq(5, 5).visualDirection(to: sq(7, 10)) == .south)
        #expect(sq(5, 5).visualDirection(to: sq(6, 10)) == .south)
        #expect(sq(5, 5).visualDirection(to: sq(5, 10)) == .south)
        #expect(sq(5, 5).visualDirection(to: sq(4, 10)) == .south)
        #expect(sq(5, 5).visualDirection(to: sq(3, 10)) == .south)
        #expect(sq(5, 5).visualDirection(to: sq(2, 10)) == .southWest)
        #expect(sq(5, 5).visualDirection(to: sq(1, 10)) == .southWest)
        #expect(sq(5, 5).visualDirection(to: sq(0, 10)) == .southWest)
        #expect(sq(5, 5).visualDirection(to: sq(0, 9)) == .southWest)
        #expect(sq(5, 5).visualDirection(to: sq(0, 8)) == .southWest)
        #expect(sq(5, 5).visualDirection(to: sq(0, 7)) == .west)
        #expect(sq(5, 5).visualDirection(to: sq(0, 6)) == .west)
        #expect(sq(5, 5).visualDirection(to: sq(0, 5)) == .west)
        #expect(sq(5, 5).visualDirection(to: sq(0, 4)) == .west)
        #expect(sq(5, 5).visualDirection(to: sq(0, 3)) == .west)
        #expect(sq(5, 5).visualDirection(to: sq(0, 2)) == .northWest)
        #expect(sq(5, 5).visualDirection(to: sq(0, 1)) == .northWest)
        #expect(sq(5, 5).visualDirection(to: sq(0, 0)) == .northWest)
        #expect(sq(5, 5).visualDirection(to: sq(1, 0)) == .northWest)
        #expect(sq(5, 5).visualDirection(to: sq(2, 0)) == .northWest)
        #expect(sq(5, 5).visualDirection(to: sq(3, 0)) == .north)
        #expect(sq(5, 5).visualDirection(to: sq(4, 0)) == .north)
    }
}
