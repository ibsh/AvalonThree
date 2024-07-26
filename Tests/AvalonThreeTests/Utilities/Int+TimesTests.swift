//
//  Int+TimesTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Testing
@testable import AvalonThree

struct IntTimesTests {

    @Test func testTimesNegative() async throws {
        var value = 0
        var indices = [Int]()
        (-4).times { index in
            value += 1
            indices.append(index)
        }
        #expect(value == 0)
        #expect(indices == [])
    }

    @Test func testTimesZero() async throws {
        var value = 0
        var indices = [Int]()
        0.times { index in
            value += 1
            indices.append(index)
        }
        #expect(value == 0)
        #expect(indices == [])
    }

    @Test func testTimesOne() async throws {
        var value = 0
        var indices = [Int]()
        1.times { index in
            value += 1
            indices.append(index)
        }
        #expect(value == 1)
        #expect(indices == [0])
    }

    @Test func testTimesMore() async throws {
        var value = 0
        var indices = [Int]()
        4.times { index in
            value += 1
            indices.append(index)
        }
        #expect(value == 4)
        #expect(indices == [0, 1, 2, 3])
    }

    @Test func testReduceNegative() async throws {
        #expect((-15).reduce(2, { $0 * 2 }) == 2)
    }

    @Test func testReduceZero() async throws {
        #expect(0.reduce(2, { $0 * 2 }) == 2)
    }

    @Test func testReduceOne() async throws {
        #expect(1.reduce(2, { $0 * 2 }) == 4)
    }

    @Test func testReduceMore() async throws {
        #expect(4.reduce(2, { $0 * 2 }) == 32)
    }
}
