//
//  ChallengeDeckID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum ChallengeDeckID: Codable {
    case shortStandard
    case shortRandomised
    case longStandard
    case longRandomised
}

extension ChallengeDeckID {
    static var availableCases: [ChallengeDeckID] {
        [
            .shortStandard,
            .shortRandomised,
            .longStandard,
            .longRandomised,
        ]
    }
}
