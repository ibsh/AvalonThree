//
//  PlayerSpec+Skill.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Foundation

extension PlayerSpec {
    enum Skill {
        /// This player can make a special Block action while Open. Choose an Open or Marked
        /// opponent within 3 squares to be the target. The Block action cannot be assisted. Treat
        /// results of "Shove" as "Miss".
        case bomber

        /// If this player is Open and is the target of a successful Pass action (not a hand-off),
        /// they can make a free Run action.
        case catchersInstincts

        /// When this player makes a Block action, roll a D6 along with the block dice. If the
        /// result is a 6, the target is automatically injured - do not resolve the block dice.
        case claws

        /// When this player makes a Run action they can move adjacent to opponents, but must end
        /// the action Open.
        case elusive

        /// ORIGINAL TEXT
        /// When this player makes a Block action, you must resolve the results of all the dice
        /// rolled, in the order of your choosing. For each knocked down result, the opposing coach
        /// must make an Armour check for the target player.
        /// MY TEXT
        /// When this player makes a Block action, you must resolve the results of all the dice
        /// rolled, in the following order: shove, smash, kerrunch, tackle, miss. For each shove
        /// result that moves the opponent, this player must follow up. For each knocked down
        /// result, the opposing coach must make an Armour check for the target player. If this
        /// player is disabled by a tackle result, all subsequent knockdowns from other tackle
        /// results are still applied.
        case enforcer

        /// When this player makes a Run action they can move adjacent to opponents and through
        /// obstructions, but must end the action Open and not on an obstruction.
        case ethereal

        /// After this player makes a Mark action, they can immediately make a free Block action.
        case frenzied

        /// Whenever this player is moved into a square containing a ball, they pick it up, as
        /// though they were making a Run action.
        case handlingSkills

        /// If this player makes a Run action, followed by a Mark action, they can immediately make
        /// a free Block action.
        case headbutt

        /// When this player makes a Block action, treat results of "Tackle" or "Smash" as
        /// "Kerrunch". In addition, if this player is the target of a Block action, treat results
        /// of "Shove" as "Miss".
        case hulkingBrute

        /// This player can perform a Hurl Team-mate (HTM) action. Making the HTM action counts as a
        /// Pass action (e.g. for claiming Challenge cards). The player must be Open, adjacent to a
        /// teammate not of the same position, and cannot have possession of a ball. Pick a target
        /// square that is not occupied by another player and that is within range, and then make a
        /// Pass check. If the check succeeds, place the hurled player standing in the target
        /// square. If the hurled player had possession of a ball, they retain possession of it. If
        /// the check fails, place the target player Prone in the target square, but do not make an
        /// Armour check. If the hurled player had possession of a ball, it bounces from the target
        /// square. If the check is a Fumble, the hurled player is injured. If the hurled player had
        /// possession of a ball, it bounces from the player making the HTM action. If a player is
        /// hurled to a square that already contains a ball, that ball bounces.
        case hurlTeammate

        /// Opponents may move or end their move adjacent to this player during a Run action. In
        /// addition, when this player makes a Block action, treat results of "Tackle" as "Miss".
        case insignificant

        /// When this player makes a Run action they can move adjacent to and through players, but
        /// must end the action Open.
        case leap

        /// When this player makes a Block action, treat results of "Smash" as "Kerrunch".
        case mightyBlow

        /// When this player makes a Block action, you can choose to re-roll the block dice.
        case offensiveSpecialist

        /// After the Pre-Turn sequence, but before making your first Player Action, if this player
        /// is prone, they can make a free Stand Up action.
        case regenerate

        /// When this player makes a Run action, they can move adjacent to opponents, but doing so
        /// ends the action.
        case rush

        /// If this player is knocked down while holding a ball, you can choose which adjacent
        /// square the ball bounces into instead of rolling a D8.
        case safeHands

        /// When this player is the target of a Block action, treat results of "Shove" as "Miss".
        case standFirm

        /// Opponents may move adjacent to this player during a Run action, but doing so ends the
        /// action. In addition, when this player makes a Block action, treat results of "Tackle" as
        /// "Miss".
        case titchy

        /// This player can make a Run action while Marked. When this player makes a Run action,
        /// they can move adjacent to opponents, and finish the action Open or Marked. This player's
        /// Block actions cannot be assisted.
        case warMachine
    }
}
