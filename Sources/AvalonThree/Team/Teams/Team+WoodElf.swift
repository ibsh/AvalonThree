//
//  Team+WoodElf.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

extension Team {
    static var woodElf: Team {
        Team(
            id: .woodElf,
            playerSpecIDs: [
                .woodElf_lineman,
                .woodElf_lineman,
                .woodElf_lineman,
                .woodElf_passer,
                .woodElf_catcher,
                .woodElf_wardancer,
            ],
            emergencyReserves: 4
        )
    }
}
