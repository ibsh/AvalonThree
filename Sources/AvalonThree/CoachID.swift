//
//  Coach.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum CoachID: String, CaseIterable, Codable, Sendable {
    case home
    case away
}

extension CoachID {
    public var inverse: CoachID {
        switch self {
        case .home: return .away
        case .away: return .home
        }
    }
}
