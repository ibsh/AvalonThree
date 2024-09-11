//
//  UUIDProvider.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/20/24.
//

import Foundation

protocol UUIDProviding: Sendable {
    func generate() -> UUID
}

final class DefaultUUIDProvider: UUIDProviding {
    func generate() -> UUID {
        UUID()
    }
}
