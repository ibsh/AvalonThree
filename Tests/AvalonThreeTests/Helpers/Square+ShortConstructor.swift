//
//  Square+ShortConstructor.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 7/15/24.
//

import Foundation
@testable import AvalonThree

func sq(_ x: Int, _ y: Int) -> Square {
    Square(x: x, y: y)!
}

func squares(_ longString: String) -> Set<Square> {
    let lines = longString.components(separatedBy: .newlines)
    guard lines.count == Square.Constants.yRange.count else {
        fatalError("Invalid row count")
    }
    var output = Set<Square>()
    for (row, line) in lines.map({ $0.trimmingCharacters(in: .whitespaces) }).enumerated() {
        guard line.count == Square.Constants.xRange.count else {
            fatalError("Invalid column count")
        }
        for (column, stringElement) in line.enumerated() {
            if Set(arrayLiteral: "a", "A").contains(stringElement) {
                output.insert(sq(column, row))
            }
        }
    }
    return output
}

extension ValidMoveSquares: CustomStringConvertible {
    public var description: String {
        var result = "\nVMS:\nintermediate: squares(\"\"\"\n"
        for y in Square.Constants.yRange {
            for x in Square.Constants.xRange {
                if intermediate.contains(sq(x, y)) {
                    result += "a"
                } else {
                    result += "."
                }
            }
            result += "\n"
        }
        result += "\"\"\"),\nfinal: squares(\"\"\"\n"
        for y in Square.Constants.yRange {
            for x in Square.Constants.xRange {
                if final.contains(sq(x, y)) {
                    result += "a"
                } else {
                    result += "."
                }
            }
            result += "\n"
        }
        result += "\"\"\")\n\n"
        return result
    }
}
