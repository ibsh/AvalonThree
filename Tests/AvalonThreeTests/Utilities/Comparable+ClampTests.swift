//
//  Comparable+ClampTests.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/18/24.
//

import Testing
@testable import AvalonThree

struct ComparableClampTests {

    @Test func testInt() async throws {
        #expect((-1).clamp(0...10) == 0)
        #expect((0).clamp(0...10) == 0)
        #expect((3).clamp(0...10) == 3)
        #expect((6).clamp(0...10) == 6)
        #expect((10).clamp(0...10) == 10)
        #expect((11).clamp(0...10) == 10)
    }

    @Test func testDouble() async throws {
        #expect((-0.1).clamp(0.0...1.0) == 0.0)
        #expect((0.0).clamp(0.0...1.0) == 0.0)
        #expect((0.5).clamp(0.0...1.0) == 0.5)
        #expect((1.0).clamp(0.0...1.0) == 1.0)
        #expect((1.1).clamp(0.0...1.0) == 1.0)
    }
}
