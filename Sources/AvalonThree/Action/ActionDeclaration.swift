//
//  ActionDeclaration.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/29/24.
//

import Foundation

struct ValidDeclaration: Hashable, Codable, Sendable {
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
    let consumesBonusPlays: Set<BonusPlay>
}

public struct ActionDeclaration: Hashable, Codable, Sendable {
    public let playerID: PlayerID
    public let actionID: ActionID
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

extension ValidDeclaration {
    func toPromptDeclaration() -> PromptValidDeclaration {
        PromptValidDeclaration(
            actionID: actionID,
            consumesBonusPlays: consumesBonusPlays
        )
    }
}

extension Collection where Element == ValidDeclaration {
    func toPromptDeclarations(table: Table) -> Set<PromptValidDeclaringPlayer> {
        sorted { $0.actionID.sortOrder < $1.actionID.sortOrder }
            .reduce([]) { partialResult, declaration in
                var partialResult = partialResult
                var value = partialResult.removeFirst(
                    where: { $0.playerID == declaration.playerID }
                ) ?? PromptValidDeclaringPlayer(
                    playerID: declaration.playerID,
                    square: table.getPlayer(id: declaration.playerID)?.square,
                    declarations: []
                )
                value.declarations.append(
                    PromptValidDeclaration(
                        actionID: declaration.actionID,
                        consumesBonusPlays: declaration.consumesBonusPlays
                    )
                )
                return partialResult + [value]
            }
            .toSet()
    }
}

extension ActionDeclaration {
    var coachID: CoachID {
        playerID.coachID
    }
}

private extension ActionID {

    var sortOrder: Int {
        switch self {
        case .run: 0
        case .mark: 1
        case .pass: 2
        case .hurlTeammate: 3
        case .foul: 4
        case .block: 5
        case .sidestep: 6
        case .standUp: 7
        case .reserves: 8
        }
    }
}
