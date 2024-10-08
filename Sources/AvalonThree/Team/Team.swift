//
//  Team.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/3/24.
//

import Foundation

struct Team {
    let id: TeamID
    let playerSpecIDs: [PlayerSpecID]
    let emergencyReserves: Int
}

extension Team {
    func playerSetups(coachID: CoachID) -> [PlayerSetup] {
        playerSpecIDs
            .enumerated()
            .reduce([]) { partialResult, indexAndSpecID in
                partialResult + [
                    PlayerSetup(
                        id: PlayerID(coachID: coachID, index: indexAndSpecID.0),
                        specID: indexAndSpecID.1,
                        spec: indexAndSpecID.1.spec
                    )
                ]
            }
    }
}
