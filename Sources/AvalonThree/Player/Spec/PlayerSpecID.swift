//
//  PlayerSpecID.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

public enum PlayerSpecID: Codable {
    case blackOrc_blackOrc
    case blackOrc_goblin
    case chaos_beastman
    case chaos_chosenBlocker
    case darkElf_lineman
    case darkElf_runner
    case darkElf_blitzer
    case darkElf_witchElf
    case dwarf_lineman
    case dwarf_runner
    case dwarf_blitzer
    case dwarf_trollslayer
    case elf_lineman
    case elf_passer
    case elf_catcher
    case elf_blitzer
    case goblin_goblin
    case goblin_troll
    case halfling_hopeful
    case halfling_catcher
    case halfling_hefty
    case halfling_treeman
    case human_lineman
    case human_passer
    case human_catcher
    case human_blitzer
    case khorne_marauder
    case khorne_khorngor
    case khorne_bloodseeker
    case lizardmen_skinkRunner
    case lizardmen_chameleonSkinkCatcher
    case lizardmen_saurusBlocker
    case necromantic_zombie
    case necromantic_ghoul
    case necromantic_wraith
    case necromantic_werewolf
    case necromantic_fleshGolem
    case noble_lineman
    case noble_passer
    case noble_guard
    case noble_blitzer
    case nurgle_lineman
    case nurgle_pestigor
    case nurgle_bloater
    case ogre_ogre
    case ogre_gnoblar
    case orc_lineman
    case orc_passer
    case orc_blitzer
    case orc_bigUnBlocker
    case skaven_lineman
    case skaven_passer
    case skaven_gutterRunner
    case skaven_blitzer
    case snotling_snotling
    case snotling_fungusFlinga
    case snotling_funHoppa
    case snotling_stiltyRunna
    case snotling_pumpWagon
    case undead_skeleton
    case undead_zombie
    case undead_ghoul
    case undead_wight
    case undead_mummy
    case woodElf_lineman
    case woodElf_passer
    case woodElf_catcher
    case woodElf_wardancer
}

extension PlayerSpecID {
    var spec: PlayerSpec {
        switch self {
        case .blackOrc_blackOrc: return PlayerSpec.blackOrc_blackOrc
        case .blackOrc_goblin: return PlayerSpec.blackOrc_goblin
        case .chaos_beastman: return PlayerSpec.chaos_beastman
        case .chaos_chosenBlocker: return PlayerSpec.chaos_chosenBlocker
        case .darkElf_lineman: return PlayerSpec.darkElf_lineman
        case .darkElf_runner: return PlayerSpec.darkElf_runner
        case .darkElf_blitzer: return PlayerSpec.darkElf_blitzer
        case .darkElf_witchElf: return PlayerSpec.darkElf_witchElf
        case .dwarf_lineman: return PlayerSpec.dwarf_lineman
        case .dwarf_runner: return PlayerSpec.dwarf_runner
        case .dwarf_blitzer: return PlayerSpec.dwarf_blitzer
        case .dwarf_trollslayer: return PlayerSpec.dwarf_trollslayer
        case .elf_lineman: return PlayerSpec.elf_lineman
        case .elf_passer: return PlayerSpec.elf_passer
        case .elf_catcher: return PlayerSpec.elf_catcher
        case .elf_blitzer: return PlayerSpec.elf_blitzer
        case .goblin_goblin: return PlayerSpec.goblin_goblin
        case .goblin_troll: return PlayerSpec.goblin_troll
        case .halfling_hopeful: return PlayerSpec.halfling_hopeful
        case .halfling_catcher: return PlayerSpec.halfling_catcher
        case .halfling_hefty: return PlayerSpec.halfling_hefty
        case .halfling_treeman: return PlayerSpec.halfling_treeman
        case .human_lineman: return PlayerSpec.human_lineman
        case .human_passer: return PlayerSpec.human_passer
        case .human_catcher: return PlayerSpec.human_catcher
        case .human_blitzer: return PlayerSpec.human_blitzer
        case .khorne_marauder: return PlayerSpec.khorne_marauder
        case .khorne_khorngor: return PlayerSpec.khorne_khorngor
        case .khorne_bloodseeker: return PlayerSpec.khorne_bloodseeker
        case .lizardmen_skinkRunner: return PlayerSpec.lizardmen_skinkRunner
        case .lizardmen_chameleonSkinkCatcher: return PlayerSpec.lizardmen_chameleonSkinkCatcher
        case .lizardmen_saurusBlocker: return PlayerSpec.lizardmen_saurusBlocker
        case .necromantic_zombie: return PlayerSpec.necromantic_zombie
        case .necromantic_ghoul: return PlayerSpec.necromantic_ghoul
        case .necromantic_wraith: return PlayerSpec.necromantic_wraith
        case .necromantic_werewolf: return PlayerSpec.necromantic_werewolf
        case .necromantic_fleshGolem: return PlayerSpec.necromantic_fleshGolem
        case .noble_lineman: return PlayerSpec.noble_lineman
        case .noble_passer: return PlayerSpec.noble_passer
        case .noble_guard: return PlayerSpec.noble_guard
        case .noble_blitzer: return PlayerSpec.noble_blitzer
        case .nurgle_lineman: return PlayerSpec.nurgle_lineman
        case .nurgle_pestigor: return PlayerSpec.nurgle_pestigor
        case .nurgle_bloater: return PlayerSpec.nurgle_bloater
        case .ogre_ogre: return PlayerSpec.ogre_ogre
        case .ogre_gnoblar: return PlayerSpec.ogre_gnoblar
        case .orc_lineman: return PlayerSpec.orc_lineman
        case .orc_passer: return PlayerSpec.orc_passer
        case .orc_blitzer: return PlayerSpec.orc_blitzer
        case .orc_bigUnBlocker: return PlayerSpec.orc_bigUnBlocker
        case .skaven_lineman: return PlayerSpec.skaven_lineman
        case .skaven_passer: return PlayerSpec.skaven_passer
        case .skaven_gutterRunner: return PlayerSpec.skaven_gutterRunner
        case .skaven_blitzer: return PlayerSpec.skaven_blitzer
        case .snotling_snotling: return PlayerSpec.snotling_snotling
        case .snotling_fungusFlinga: return PlayerSpec.snotling_fungusFlinga
        case .snotling_funHoppa: return PlayerSpec.snotling_funHoppa
        case .snotling_stiltyRunna: return PlayerSpec.snotling_stiltyRunna
        case .snotling_pumpWagon: return PlayerSpec.snotling_pumpWagon
        case .undead_skeleton: return PlayerSpec.undead_skeleton
        case .undead_zombie: return PlayerSpec.undead_zombie
        case .undead_ghoul: return PlayerSpec.undead_ghoul
        case .undead_wight: return PlayerSpec.undead_wight
        case .undead_mummy: return PlayerSpec.undead_mummy
        case .woodElf_lineman: return PlayerSpec.woodElf_lineman
        case .woodElf_passer: return PlayerSpec.woodElf_passer
        case .woodElf_catcher: return PlayerSpec.woodElf_catcher
        case .woodElf_wardancer: return PlayerSpec.woodElf_wardancer
        }
    }
}
