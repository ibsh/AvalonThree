//
//  BlockDieRandomizer.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/18/24.
//

import Foundation

public protocol BlockDieRandomizing {
    func rollBlockDie() -> BlockDieResult
}

public final class DefaultBlockDieRandomizer {

    private static let BlockDieFaces: Set<BlockDieResult> =
    [
        .miss,
        .shove,
        .shove,
        .tackle,
        .smash,
        .kerrunch,
    ]

    public init() { }
}

extension DefaultBlockDieRandomizer: BlockDieRandomizing {

    public func rollBlockDie() -> BlockDieResult {
        guard let result = DefaultBlockDieRandomizer.BlockDieFaces.randomElement() else {
            fatalError("No sides on my block die")
        }
        return result
    }
}
