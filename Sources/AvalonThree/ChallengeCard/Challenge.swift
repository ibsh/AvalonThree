//
//  Challenge.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum Challenge: String, Hashable, Codable, Sendable {
    // Regular challenges

    /// Claim this card if your player made a Block or Foul action and the target was injured.
    case breakSomeBones

    /// Claim this card if an opponent had possession of a ball and, following your player's action,
    /// they no longer have possession of that ball.
    case freeUpTheBall

    /// Claim this card if your player made an assisted Block action and the target was knocked
    /// down.
    case gangUp

    /// Claim this card if your player made a Run action, and your team has made three or more Run
    /// actions this turn.
    case getMoving

    /// Claim this card if your team took possession of a ball that they have not had possession of
    /// at any point during the turn.
    case getTheBall

    /// Claim this card if your player made a Run, Mark or Sidestep action and is now adjacent to
    /// two or more teammates.
    case getTogether

    /// Claim this card if your player made a successful Pass action with a negative modifier on
    /// the Pass check.
    case makeARiskyPass

    /// Claim this card if your player made a Run or Pass action, and during that action a ball was
    /// moved four squares further from your team's End Zone, and your team still has
    /// possession of that ball.
    case moveTheBall

    /// Claim this card if your player made an Action that resulted in your team scoring a
    /// touchdown.
    case showboatForTheCrowd

    /// Claim this card if your player ended an action on a trapdoor and an opponent has possession
    /// of a ball.
    case showNoFear

    /// Claim this card if your player made a successful Pass action (not a hand-off).
    case showUsACompletion

    /// Claim this card if your player made a Run or Sidestep action and none of your players are
    /// adjacent to one another.
    case spreadOut

    /// Claim this card if your player made a Block action and the target was knocked down.
    case takeThemDown

    /// Claim this card if your player made a Mark action, and at least three opponents are Marked
    /// by two or more players from your team.
    case tieThemUp

    // Endgame challenges

    /// Claim this card if your player has possession of a ball and made a Block action which
    /// resulted in the target being knocked down.
    case breakTheirLines

    /// Claim this card if your player made a Block action that resulted in the target being
    /// injured, and at least one other opponent has already been knocked down or injured this turn.
    case causeSomeCarnage

    /// Claim this card if two or more of your players are Open and within 3 squares of the other
    /// team's End Zone.
    case goDeep

    /// Claim this card if you are 4 or more points behind your opponent's score and you could not
    /// claim another Challenge card with your player's action.
    case lastChance

    /// Claim this card if 2 or more opponents are in Reserve, and your player made a Block action
    /// that resulted in the target being knocked down.
    case pileOn

    /// Claim this card if you made three or more different actions with three or more different
    /// players this turn.
    case playAsATeam

    /// Claim this card if your player made a successful long pass, and it was the second or
    /// subsequent successful pass (not a hand-off) made by your team this turn.
    case showOffALittle

    /// Claim this card if you made an Emergency Reserves action during your turn and you are 4 or
    /// more points behind your opponent's score.
    case showSomeGrit

    /// Claim this card if your player has made three or more Actions (not free actions) this turn.
    case showThemHowItsDone

    // Fake challenges

    /// This card can never be claimed as an objective, it's just to give to a new player for a free
    /// reroll.
    case rookieBonus
}

extension Challenge {
    var scoreIncrement: Int {
        switch self {
        case .lastChance,
             .showSomeGrit,
             .rookieBonus:
            return 0
        case .getTheBall,
             .getTogether,
             .moveTheBall,
             .showboatForTheCrowd,
             .showUsACompletion,
             .spreadOut:
            return 1
        case .breakTheirLines,
             .freeUpTheBall,
             .gangUp,
             .getMoving,
             .goDeep,
             .makeARiskyPass,
             .pileOn,
             .playAsATeam,
             .showNoFear,
             .showThemHowItsDone,
             .takeThemDown,
             .tieThemUp:
            return 2
        case .breakSomeBones,
             .causeSomeCarnage,
             .showOffALittle:
            return 3
        }
    }
}

extension Challenge {
    var checkedPostTouchdown: Bool {
        switch self {
        case .breakSomeBones,
             .freeUpTheBall,
             .gangUp,
             .getMoving,
             .getTheBall,
             .getTogether,
             .makeARiskyPass,
             .showboatForTheCrowd,
             .showNoFear,
             .showUsACompletion,
             .spreadOut,
             .takeThemDown,
             .tieThemUp,
             .causeSomeCarnage,
             .lastChance,
             .pileOn,
             .playAsATeam,
             .showOffALittle,
             .showSomeGrit,
             .showThemHowItsDone,
             .rookieBonus:
            true
        case .moveTheBall,
             .breakTheirLines,
             .goDeep:
            false
        }
    }
}
