//
//  Team+DarkElf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var elf: Team {
        Team(
            id: .elf,
            playerSpecIDs: [
                .elf_lineman,
                .elf_lineman,
                .elf_lineman,
                .elf_passer,
                .elf_catcher,
                .elf_blitzer,
            ],
            emergencyReserves: 4
        )
    }
}
