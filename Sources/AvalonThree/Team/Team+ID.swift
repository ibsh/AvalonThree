//
//  TeamID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum TeamID: Codable, Sendable {
    case blackOrc
    case chaos
    case darkElf
    case dwarf
    case elf
    case goblin
    case halfling
    case human
    case khorne
    case lizardmen
    case necromantic
    case noble
    case nurgle
    case ogre
    case orc
    case skaven
    case snotling
    case undead
    case woodElf
}

extension TeamID {
    var spec: Team {
        switch self {
        case .blackOrc: return Team.blackOrc
        case .chaos: return Team.chaos
        case .darkElf: return Team.darkElf
        case .dwarf: return Team.dwarf
        case .elf: return Team.elf
        case .goblin: return Team.goblin
        case .halfling: return Team.halfling
        case .human: return Team.human
        case .khorne: return Team.khorne
        case .lizardmen: return Team.lizardmen
        case .necromantic: return Team.necromantic
        case .noble: return Team.noble
        case .nurgle: return Team.nurgle
        case .ogre: return Team.ogre
        case .orc: return Team.orc
        case .skaven: return Team.skaven
        case .snotling: return Team.snotling
        case .undead: return Team.undead
        case .woodElf: return Team.woodElf
        }
    }
}

extension TeamID {
    static var availableCases: [TeamID] {
        [
            .blackOrc,
             .chaos,
             .darkElf,
             .dwarf,
             .elf,
             .goblin,
             .halfling,
             .human,
             .khorne,
             .lizardmen,
             .necromantic,
             .noble,
             .nurgle,
             .ogre,
             .orc,
             .skaven,
             .snotling,
             .undead,
             .woodElf,
        ]
    }
}
