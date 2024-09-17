//
//  BoardSpecID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum BoardSpecID: String, Codable, Sendable {
    case season1Board1
    case season1Board2
    case season2Board1
    case season2Board2
    case season3Board1
    case season3Board2
}

extension BoardSpecID {
    public var spec: BoardSpec {
        switch self {
        case .season1Board1: return BoardSpec.season1Board1
        case .season1Board2: return BoardSpec.season1Board2
        case .season2Board1: return BoardSpec.season2Board1
        case .season2Board2: return BoardSpec.season2Board2
        case .season3Board1: return BoardSpec.season3Board1
        case .season3Board2: return BoardSpec.season3Board2
        }
    }
}

extension BoardSpecID {
    static var availableCases: [BoardSpecID] {
        [
            .season1Board1,
            .season1Board2,
            .season2Board1,
            .season2Board2,
            .season3Board1,
            .season3Board2,
        ]
    }
}
