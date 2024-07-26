//
//  UUIDProviderDouble.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation
@testable import AvalonThree

final class UUIDProviderDouble: UUIDProviding {

    var nextResults: [UUID] = []

    func generate() -> UUID {
        nextResults.popFirst() ?? DefaultUUIDProvider().generate()
    }
}
