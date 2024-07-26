//
//  BoardSpecID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum BoardSpecID: Codable {
    case whiteWolfHolm
    case altdorfOldTown
    case barakVarrFoundry
    case ghrondGridiron
    case oghamStoneCrush
    case bilbaliHarbor
}

extension BoardSpecID {
    var spec: BoardSpec {
        switch self {
        case .whiteWolfHolm: return BoardSpec.whiteWolfHolm
        case .altdorfOldTown: return BoardSpec.altdorfOldTown
        case .barakVarrFoundry: return BoardSpec.barakVarrFoundry
        case .ghrondGridiron: return BoardSpec.ghrondGridiron
        case .oghamStoneCrush: return BoardSpec.oghamStoneCrush
        case .bilbaliHarbor: return BoardSpec.bilbaliHarbor
        }
    }
}

extension BoardSpecID {
    static var availableCases: [BoardSpecID] {
        [
            .whiteWolfHolm,
            .altdorfOldTown,
            .barakVarrFoundry,
            .ghrondGridiron,
            .oghamStoneCrush,
            .bilbaliHarbor,
        ]
    }
}
