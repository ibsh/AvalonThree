//
//  Team+DarkElf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var darkElf: Team {
        Team(
            id: .darkElf,
            playerSpecIDs: [
                .darkElf_lineman,
                .darkElf_lineman,
                .darkElf_lineman,
                .darkElf_runner,
                .darkElf_blitzer,
                .darkElf_witchElf,
            ],
            emergencyReserves: 4
        )
    }
}
