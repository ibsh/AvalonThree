//
//  Square+Path+IsPassable.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Foundation

extension InGameTransaction {

    func buildMoveValidationFunction(
        playerID: PlayerID,
        reason: PlayerMoveReason
    ) -> Square.MoveValidationFunction {
        { square, isFinalSquare in
            switch try playerCanMoveIntoSquare(
                playerID: playerID,
                newSquare: square,
                isFinalSquare: isFinalSquare,
                reason: reason
            ) {
            case .canMove:
                true
            case .cannotMove:
                false
            }
        }
    }
}
