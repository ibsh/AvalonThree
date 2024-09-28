//
//  BonusPlay.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum BonusPlay: String, Codable, Sendable {
    // Regular bonus plays

    /// Play this card before your player makes a Pass action that is a short pass. Treat the
    /// player as having a Pass stat of 2+ for that action.
    case accuratePass

    /// Play this card after your player makes a Mark action, and has already made a Run action this
    /// turn. That player immediately makes a free Block action against an opponent they are
    /// marking.
    case blitz

    /// Play this card on your turn at any time after the Pre-Turn Sequence. Players from your
    /// team can move adjacent to opponents when making Run actions during this turn, but doing so
    /// ends their Run action.
    case blockingPlay

    /// Play this card at the start of your turn, before the Pre-Turn Sequence. Block actions made
    /// by your players this turn count as being assisted.
    case defensivePlay

    /// Play this card after an opponent makes a Mark action but before the Claim Challenge Card
    /// step. One of your players adjacent to that opponent can immediately make a free Sidestep
    /// action.
    case distraction

    /// Play this card after your player makes a Mark action. That player immediately makes a free
    /// Block action against an opponent they are marking. After making the Block action, place the
    /// player Prone but do not make an Armour check. If they were carrying a ball, it bounces.
    case divingTackle

    /// Play this card before your player makes a Run action. During that action the player can move
    /// adjacent to opponents, but must still end the move Open.
    case dodge

    /// Play this card after the Claim Challence Card step of your third Player Action. Immediately
    /// take a fourth Player Action, which is still part of your turn and follows all the rules for
    /// actions and claiming Challenge cards.
    case inspiration

    /// Play this card before your player makes a Mark action. They can move up to 4 squares instead
    /// of two, but must still end the action Marked.
    case interference

    /// Play this card after an opponent makes a Run action but before the Claim Challenge Card
    /// step. One Open player from your team may immediately make a free Mark action but must end it
    /// adjacent to the opponent that made the Run action.
    case intervention

    /// Play this card at the start of your turn, after the Pre-Turn Sequence but before making your
    /// first Player Action. Pick a Prone player on your team and make a free Stand Up action.
    case jumpUp

    /// Play this card immediately - do not add it to your hand. Two new balls come into play,
    /// following the rules for "New Ball" and "Multiple Balls In Play".
    case multiBall

    /// Play this card after you make an Armour Check, a Pass Check or roll the dice for a Block
    /// action. Re-roll the dice.
    case rawTalent

    /// Play this card at the start of your turn, after the Pre-Turn Sequence but before making your
    /// first Player Action. Make a free Reserves action.
    case reserves

    /// Play this card after an opponent makes a Sidestep action. One of your players that was
    /// marking that opponent before the action may move into the square the opponent moved out of.
    case shadow

    /// Play this card before your player makes a Run action. They can move an additional 2 squares.
    case sprint

    /// Play this card after an opponent targets your player with a Block action but before the dice
    /// are rolled. Your player immediately makes a free Sidestep action (after which they must be
    /// Open). The opponent's Block action is cancelled and does not count as having been made.
    case stepAside

    /// Play this card at the start of your turn, before the Pre-Turn Sequence. Pass checks during
    /// this turn are made with a D8, and a result of 6+ before or after modification always
    /// succeeds.
    case passingPlay

    /// Play this card before you make an Armour check for your player. The check is made with a D8,
    /// and an unmodified result of 6+ always succeeds.
    case toughEnough

    // Endgame bonus plays

    /// Play this card before your opponent makes an Armour check. Subtract 2 from the check, in
    /// addition to any other modifiers, to a minimum result of 1.
    case absoluteCarnage

    /// Play this card before making an Armour check. An unmodified result of 2 or more will succeed
    /// for that check.
    case absolutelyNails

    /// Play this card after your player knocks an opponent down. The opponent is automatically
    /// injured; do not make an Armour check.
    case bladedKnuckleDusters

    /// Play this card after your player makes a Block action but before you roll the dice. The
    /// result is automatically Kerrunch; do not roll the dice.
    case bodyCheck

    /// Play this card immediately - do not add it to your hand. For the remainder of the game, your
    /// opponent cannot make free Reserves actions during the Emergency Reserves step of the Pre-
    /// Turn Sequence.
    case bribedRef

    /// Play this card after your player takes possession of the ball as the result of a Pass
    /// action, before the Claim Challenge Card step. They can immediately make a free Run action
    /// (if Open) or Sidestep action (if Marked).
    case comboPlay

    /// Play this card after your player is placed in Reserve as the result of being injured.
    /// Immediately make a free Reserves action with that player.
    case getInThere

    /// Play this card when your player makes a Pass action, before choosing the target. The
    /// target can be a teammate anywhere on the board and the check will succeed on a result of 4+,
    /// regardless of any other conditions. A result of 1 before or after modification results in a
    /// fumble.
    case hailMaryPass

    /// Play this card after your team claims a different Challenge card or scores a touchdown.
    /// Score 1 extra point.
    case legUp

    /// Play this card before you make a Player Action. For that action, your player can make a
    /// Pass (or Hurl Teammate) action, even if they are Marked.
    case nervesOfSteel

    /// Play this card immediately - do not add it to your hand. Block actions made by your players
    /// count as being assisted until the end of the game.
    case nufflesBlessing

    /// Play this card before you make a Pass or Armour check. The check is made with a D8, and a
    /// result of 6+ before or after modification always succeeds.
    case pro

    /// Play this card immediately - do not add it to your hand. Each Open player on your team may
    /// make a free Run action of 1 square only. Then each Marked player on your team can make a
    /// free Sidestep action. Then, each Prone player on your team can make a free Stand Up action.
    case readyToGo

    /// Play this card after a player from your team makes a Mark action. The player immediately
    /// makes a free Block action that targets an opponent they are marking.
    case shoulderCharge

    /// Play this card when your player makes an unassisted Block action. Roll three dice for that
    /// Block action.
    case theKidsGotMoxy

    /// Play this card immediately - do not add it to your hand. Make up to two free Reserves
    /// actions. One player that has made a Reserves action this turn can make a free Run action.
    case yourTimeToShine
}

extension BonusPlay {

    enum Persistence: Equatable {
        case instant
        case oneAction
        case oneTurn
        case custom
        case game
    }

    var persistence: Persistence {
        switch self {
        case .legUp:
            return .instant
        case .accuratePass,
             .blitz,
             .distraction,
             .divingTackle,
             .dodge,
             .inspiration,
             .interference,
             .intervention,
             .jumpUp,
             .reserves,
             .sprint,
             .stepAside,
             .toughEnough,
             .absoluteCarnage,
             .absolutelyNails,
             .bladedKnuckleDusters,
             .bodyCheck,
             .comboPlay,
             .getInThere,
             .hailMaryPass,
             .nervesOfSteel,
             .pro,
             .shoulderCharge,
             .theKidsGotMoxy:
            return .oneAction
        case .blockingPlay,
             .defensivePlay,
             .passingPlay:
            return .oneTurn
        case .multiBall,
             .rawTalent,
             .shadow,
             .readyToGo,
             .yourTimeToShine:
            return .custom
        case .bribedRef,
             .nufflesBlessing:
            return .game
        }
    }
}
