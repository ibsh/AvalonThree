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

    @Test func testInvalidAngleToEqual() async throws {
        #expect(sq(5, 5).angle(to: sq(5, 5)) == nil)
    }

    @Test func testValidAngleToAdjacent() async throws {
        #expect(sq(5, 5).angle(to: sq(5, 4)) == 0)
        #expect(sq(5, 5).angle(to: sq(6, 4)) == 45)
        #expect(sq(5, 5).angle(to: sq(6, 5)) == 90)
        #expect(sq(5, 5).angle(to: sq(6, 6)) == 135)
        #expect(sq(5, 5).angle(to: sq(5, 6)) == 180)
        #expect(sq(5, 5).angle(to: sq(4, 6)) == 225)
        #expect(sq(5, 5).angle(to: sq(4, 5)) == 270)
        #expect(sq(5, 5).angle(to: sq(4, 4)) == 315)
    }

    @Test func testValidAngleToDistant() async throws {
        #expect(sq(5, 5).angle(to: sq(5, 0))! == 0)
        #expect(sq(5, 5).angle(to: sq(6, 0))! == 11)
        #expect(sq(5, 5).angle(to: sq(7, 0))! == 22)
        #expect(sq(5, 5).angle(to: sq(8, 0))! == 31)
        #expect(sq(5, 5).angle(to: sq(9, 0))! == 39)
        #expect(sq(5, 5).angle(to: sq(10, 0))! == 45)
        #expect(sq(5, 5).angle(to: sq(10, 1))! == 51)
        #expect(sq(5, 5).angle(to: sq(10, 2))! == 59)
        #expect(sq(5, 5).angle(to: sq(10, 3))! == 68)
        #expect(sq(5, 5).angle(to: sq(10, 4))! == 79)
        #expect(sq(5, 5).angle(to: sq(10, 5))! == 90)
        #expect(sq(5, 5).angle(to: sq(10, 6))! == 101)
        #expect(sq(5, 5).angle(to: sq(10, 7))! == 112)
        #expect(sq(5, 5).angle(to: sq(10, 8))! == 121)
        #expect(sq(5, 5).angle(to: sq(10, 9))! == 129)
        #expect(sq(5, 5).angle(to: sq(10, 10))! == 135)
        #expect(sq(5, 5).angle(to: sq(9, 10))! == 141)
        #expect(sq(5, 5).angle(to: sq(8, 10))! == 149)
        #expect(sq(5, 5).angle(to: sq(7, 10))! == 158)
        #expect(sq(5, 5).angle(to: sq(6, 10))! == 169)
        #expect(sq(5, 5).angle(to: sq(5, 10))! == 180)
        #expect(sq(5, 5).angle(to: sq(4, 10))! == 191)
        #expect(sq(5, 5).angle(to: sq(3, 10))! == 202)
        #expect(sq(5, 5).angle(to: sq(2, 10))! == 211)
        #expect(sq(5, 5).angle(to: sq(1, 10))! == 219)
        #expect(sq(5, 5).angle(to: sq(0, 10))! == 225)
        #expect(sq(5, 5).angle(to: sq(0, 9))! == 231)
        #expect(sq(5, 5).angle(to: sq(0, 8))! == 239)
        #expect(sq(5, 5).angle(to: sq(0, 7))! == 248)
        #expect(sq(5, 5).angle(to: sq(0, 6))! == 259)
        #expect(sq(5, 5).angle(to: sq(0, 5))! == 270)
        #expect(sq(5, 5).angle(to: sq(0, 4))! == 281)
        #expect(sq(5, 5).angle(to: sq(0, 3))! == 292)
        #expect(sq(5, 5).angle(to: sq(0, 2))! == 301)
        #expect(sq(5, 5).angle(to: sq(0, 1))! == 309)
        #expect(sq(5, 5).angle(to: sq(0, 0))! == 315)
        #expect(sq(5, 5).angle(to: sq(1, 0))! == 321)
        #expect(sq(5, 5).angle(to: sq(2, 0))! == 329)
        #expect(sq(5, 5).angle(to: sq(3, 0))! == 338)
        #expect(sq(5, 5).angle(to: sq(4, 0))! == 349)
    }
}
