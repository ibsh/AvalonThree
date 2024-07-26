//
//  GameMutationError.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/12/24.
//

import Foundation

struct GameError: Error, Equatable {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}
