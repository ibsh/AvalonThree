//
//  Square+Path.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/13/24.
//

import Foundation

extension Square {

    typealias MoveValidationFunction = (_ square: Square, _ isFinalSquare: Bool) throws -> Bool

    static func optimalPath(
        from start: Square,
        to end: Square,
        isValid: MoveValidationFunction
    ) throws -> [Square]? {
        var openList = Set<AStarNode>()
        var closedList = Set<AStarNode>()

        if try !isValid(end, true) {
            return nil
        }

        openList.update(
            with: AStarNode(
                square: start,
                parent: nil,
                g: 0,
                h: start.naiveDistance(to: end)
            )
        )

        while !openList.isEmpty {
            let currentNode =
            openList
                .sorted(by: { $0.f < $1.f })
                .first!

            openList.remove(currentNode)
            closedList.update(with: currentNode)

            if currentNode.square == end {
                var path = [Square]()
                var node = currentNode
                while true {
                    if let parent = node.parent {
                        path.append(node.square)
                        node = parent
                    } else {
                        break
                    }
                }
                return path.reversed()
            }

            for childSquare in currentNode.square.adjacentSquares {
                if try !isValid(childSquare, childSquare == end) { continue }
                if closedList.contains(where: { $0.square == childSquare }) { continue }

                let adjacentNode = AStarNode(
                    square: childSquare,
                    parent: currentNode,
                    g: currentNode.g + 1,
                    h: childSquare.naiveDistance(to: end)
                )

                if let existingNode = openList.first(where: { $0.square == childSquare }) {
                    if adjacentNode.g >= existingNode.g {
                        continue
                    }
                    openList.remove(existingNode)
                }

                openList.update(with: adjacentNode)
            }
        }

        return nil
    }

    static func optimalPath(
        from start: Square,
        via mid: Square,
        toOneOf ends: Set<Square>,
        isValid: MoveValidationFunction
    ) throws -> [Square]? {
        guard !ends.isEmpty else { throw GameError("No end squares") }
        guard
            let firstPath = try optimalPath(
                from: start,
                to: mid,
                isValid: { sq, _ in try isValid(sq, false) }
            ),
            let secondPath = try optimalPath(
                from: mid,
                to: ends.sorted(
                    by: { $0.naiveDistance(to: mid) < $1.naiveDistance(to: mid )}
                ).first!,
                isValid: isValid
            )
        else {
            return nil
        }
        return firstPath + secondPath
    }

    private final class AStarNode: Hashable {
        let square: Square
        let parent: AStarNode?
        var g: Int
        let h: Int

        var f: Int {
            g + h
        }

        init(square: Square, parent: AStarNode?, g: Int, h: Int) {
            self.square = square
            self.parent = parent
            self.g = g
            self.h = h
        }

        static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
            lhs.square == rhs.square
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(square)
        }
    }
}
