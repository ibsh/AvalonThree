//
//  RookieBonusRecipientID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 9/12/24.
//

import Foundation

public enum RookieBonusRecipientID: String, CaseIterable, Codable, Sendable {
    case noOne
    case coinFlipLoser
    case coinFlipWinner
}

extension RookieBonusRecipientID {
    static var availableCases: [RookieBonusRecipientID] {
        [
            .noOne,
            .coinFlipLoser,
            .coinFlipWinner,
        ]
    }
}
