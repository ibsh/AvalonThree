//
//  ActionDeclaration.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/29/24.
//

import Foundation

public struct ValidDeclaration: Hashable, Codable, Sendable {
    let declaration: ActionDeclaration
    /// Some bonus plays, when available in the player's hand, increase the set of valid
    /// declarations they may make.
    ///
    /// The relevant bonus plays are:
    /// 1. Interference (which enables marking from a greater distance)
    /// 2. Nerves of Steel (which enables passing or hurling a teammate when marked)
    /// 3. Hail Mary Pass (which enables passing to anywhere on the board, and can combine with
    ///    Nerves of Steel)
    ///
    /// These are logically distinct (though not disjoint) from bonus plays which may be applied
    /// after an action is declared.
    let consumesBonusPlays: [BonusPlay]
}

public struct ActionDeclaration: Hashable, Codable, Sendable {
    let playerID: PlayerID
    let actionID: ActionID
}

extension ValidDeclaration {

    var playerID: PlayerID {
        declaration.playerID
    }

    var coachID: CoachID {
        playerID.coachID
    }

    var actionID: ActionID {
        declaration.actionID
    }
}

extension ActionDeclaration {
    var coachID: CoachID {
        playerID.coachID
    }
}
