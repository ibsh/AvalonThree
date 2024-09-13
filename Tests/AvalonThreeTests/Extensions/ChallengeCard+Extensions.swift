//
//  ChallengeCard+Extensions.swift
//  AvalonThreeTests
//
//  Created by Ibrahim Sha'ath on 6/5/24.
//

import Foundation
@testable import AvalonThree

extension ChallengeCard: Comparable {

    public static func == (lhs: ChallengeCard, rhs: ChallengeCard) -> Bool {
        lhs.challenge == rhs.challenge && lhs.bonusPlay == rhs.bonusPlay
    }

    public static func < (lhs: ChallengeCard, rhs: ChallengeCard) -> Bool {
        if lhs.challenge == rhs.challenge {
            return lhs.bonusPlay < rhs.bonusPlay
        }
        return lhs.challenge < rhs.challenge
    }
}
