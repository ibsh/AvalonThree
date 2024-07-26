//
//  Test.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Testing
@testable import AvalonThree

struct ArrayPopFirstTests {

    @Test func popFirstWithElements() async throws {
        var array = [1, 2, 3]
        let one = array.popFirst()
        let two = array.popFirst()
        let three = array.popFirst()
        #expect(array == [])
        #expect(one == 1)
        #expect(two == 2)
        #expect(three == 3)
    }

    @Test func popFirstWithoutElements() async throws {
        var array = ["one"]
        let one = array.popFirst()
        let two = array.popFirst()
        #expect(array == [])
        #expect(one == "one")
        #expect(two == nil)
    }
}
