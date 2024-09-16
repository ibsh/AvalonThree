//
//  GameMutationError.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

public struct GameError: Error, Equatable {
    public let message: String

    init(_ message: String) {
        self.message = message
    }
}
