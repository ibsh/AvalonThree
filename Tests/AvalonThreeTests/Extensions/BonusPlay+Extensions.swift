//
//  BonusPlay+Extensions.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/5/24.
//

import Foundation
@testable import AvalonThree

extension BonusPlay: Comparable {
    fileprivate var ordinal: Int {
        switch self {
        case .accuratePass: 1
        case .blitz: 2
        case .blockingPlay: 3
        case .defensivePlay: 4
        case .distraction: 5
        case .divingTackle: 6
        case .dodge: 7
        case .inspiration: 8
        case .interference: 9
        case .intervention: 10
        case .jumpUp: 11
        case .multiBall: 12
        case .rawTalent: 13
        case .reserves: 14
        case .shadow: 15
        case .sprint: 16
        case .stepAside: 17
        case .passingPlay: 18
        case .toughEnough: 19
        case .absoluteCarnage: 20
        case .absolutelyNails: 21
        case .bladedKnuckleDusters: 22
        case .bodyCheck: 23
        case .bribedRef: 24
        case .comboPlay: 25
        case .getInThere: 26
        case .hailMaryPass: 27
        case .legUp: 28
        case .nervesOfSteel: 29
        case .nufflesBlessing: 30
        case .pro: 31
        case .readyToGo: 32
        case .shoulderCharge: 33
        case .theKidsGotMoxy: 34
        case .yourTimeToShine: 35
        }
    }

    public static func < (lhs: BonusPlay, rhs: BonusPlay) -> Bool {
        lhs.ordinal < rhs.ordinal
    }
}
