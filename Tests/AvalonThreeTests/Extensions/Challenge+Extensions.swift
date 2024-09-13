//
//  Challenge+Extensions.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/5/24.
//

import Foundation
@testable import AvalonThree

extension Challenge: Comparable {
    fileprivate var ordinal: Int {
        switch self {
        case .breakSomeBones: 1
        case .freeUpTheBall: 2
        case .gangUp: 3
        case .getMoving: 4
        case .getTheBall: 5
        case .getTogether: 6
        case .makeARiskyPass: 7
        case .moveTheBall: 8
        case .showboatForTheCrowd: 9
        case .showNoFear: 10
        case .showUsACompletion: 11
        case .spreadOut: 12
        case .takeThemDown: 13
        case .tieThemUp: 14
        case .breakTheirLines: 15
        case .causeSomeCarnage: 16
        case .goDeep: 17
        case .lastChance: 18
        case .pileOn: 19
        case .playAsATeam: 20
        case .showOffALittle: 21
        case .showSomeGrit: 22
        case .showThemHowItsDone: 23
        case .rookieBonus: 24
        }
    }

    public static func < (lhs: Challenge, rhs: Challenge) -> Bool {
        lhs.ordinal < rhs.ordinal
    }
}
