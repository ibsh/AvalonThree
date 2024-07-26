//
//  Team+Elf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var dwarf: Team {
        Team(
            id: .dwarf,
            playerSpecIDs: [
                .dwarf_lineman,
                .dwarf_lineman,
                .dwarf_lineman,
                .dwarf_runner,
                .dwarf_blitzer,
                .dwarf_trollslayer,
            ],
            emergencyReserves: 4
        )
    }
}
