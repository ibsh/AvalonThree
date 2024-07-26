//
//  BlockDieRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

protocol BlockDieRandomizing {
    func rollBlockDie() -> BlockDieResult
}

struct DefaultBlockDieRandomizer: BlockDieRandomizing {

    private static let BlockDieFaces: Set<BlockDieResult> =
        [
            .miss,
            .shove,
            .shove,
            .tackle,
            .smash,
            .kerrunch,
        ]

    func rollBlockDie() -> BlockDieResult {
        guard let result = DefaultBlockDieRandomizer.BlockDieFaces.randomElement() else {
            fatalError("No sides on my block die")
        }
        return result
    }
}
