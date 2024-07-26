//
//  Array+RemoveFirstTests.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 7/4/24.
//

import Testing
@testable import AvalonThree

struct ArrayRemoveFirstTests {

    @Test func removeFirstWithMatchingElements() async throws {
        var array = [3, 2, 3, 2, 1]
        let removed = array.removeFirst(where: { $0 == 2 })
        #expect(array == [3, 3, 2, 1])
        #expect(removed == .some(2))
    }

    @Test func popFirstWithoutMatchingElements() async throws {
        var array = [3, 2, 3, 2, 1]
        let removed = array.removeFirst(where: { $0 == 4 })
        #expect(array == [3, 2, 3, 2, 1])
        #expect(removed == nil)
    }
}
