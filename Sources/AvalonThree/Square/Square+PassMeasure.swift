//
//  Square+PassMeasure.swift
//  AvalonThree
//
//  Created by Ibrahim Sha'ath on 6/14/24.
//

import Foundation

extension Square {

    func measurePass(
        to target: Square,
        hailMaryPass: Bool
    ) -> PassMeasure? {

        let dX = target.x - x
        let dY = target.y - y
        let absDX = abs(dX)
        let absDY = abs(dY)

        let distance: PassDistance? = {
            switch (absDX, absDY) {
            case (0, 0): nil
            case (0, 1), (1, 0), (1, 1): .handoff
            default:
                switch sqrt(pow(Double(absDX), 2) + pow(Double(absDY), 2)) {
                case 0...4.9: .short
                case 4...8.9: .long
                default: hailMaryPass ? .long : nil
                }
            }
        }()

        guard let distance else {
            return nil
        }

        let touchingSquares: Set<Square> = {
            switch distance {
            case .handoff:
                return []
            case .short, .long:
                break
            }

            // Touching squares are determined by an adapted supercover version of Bresenham's
            // algorithm, derived from https://gamedev.stackexchange.com/a/182143/63053. Since I
            // need to check a wide band rather than a single line, I build two lines, one for each
            // side of the band, and combine their results.

            let rulerWidth = 0.99
            // TODO divbyzero is fine?
            let angle = atan(Double(dX) / Double(dY))
            let clockwiseLineXOffset = 0.5 - cos(angle) * 0.5 * rulerWidth
            let clockwiseLineYOffset = 0.5 + sin(angle) * 0.5 * rulerWidth

            let clockwiseLineTouches = touches(
                startX: Double(x) + clockwiseLineXOffset,
                startY: Double(y) + clockwiseLineYOffset,
                endX: Double(target.x) + clockwiseLineXOffset,
                endY: Double(target.y) + clockwiseLineYOffset
            )

            let antiClockwiseLineTouches = touches(
                startX: Double(x) + 1 - clockwiseLineXOffset,
                startY: Double(y) + 1 - clockwiseLineYOffset,
                endX: Double(target.x) + 1 - clockwiseLineXOffset,
                endY: Double(target.y) + 1 - clockwiseLineYOffset
            )

            return
                clockwiseLineTouches
                .union(antiClockwiseLineTouches)
                .subtracting([self, target])
        }()

        return PassMeasure(distance: distance, touchingSquares: touchingSquares)
    }

    private enum Sign {
        case positive
        case zero
        case negative

        static func get<T: Numeric & Comparable>(_ value: T) -> Self {
            if value > T.zero {
                return .positive
            } else if value < T.zero {
                return .negative
            } else {
                return .zero
            }
        }
    }

    private func touches(
        startX: Double,
        startY: Double,
        endX: Double,
        endY: Double
    ) -> Set<Square> {
        let diffX = endX - startX
        let diffY = endY - startY
        let angle = atan2(-diffY, diffX)

        let xOffset = endX > startX ? (ceil(startX) - startX) : (startX - floor(startX))
        let yOffset = endY > startY ? (ceil(startY) - startY) : (startY - floor(startY))

        let cosAngle = cos(angle)
        let sinAngle = sin(angle)

        // TODO divbyzero is fine?
        var tMaxX = xOffset / cosAngle
        var tMaxY = yOffset / sinAngle
        let tDeltaX = 1.0 / cosAngle
        let tDeltaY = 1.0 / sinAngle

        var result = Set<Square>()

        var x = Int(startX)
        var y = Int(startY)
        let stepX = {
            switch Sign.get(diffX) {
            case .positive:
                return 1
            case .zero:
                return 0
            case .negative:
                return -1
            }
        }()
        let stepY = {
            switch Sign.get(diffY) {
            case .positive:
                return 1
            case .zero:
                return 0
            case .negative:
                return -1
            }
        }()

        let taxicab = abs(Int(endX) - Int(startX)) + abs(Int(endY) - Int(startY))
        for _ in 0...taxicab {
            if let square = Square(x: x, y: y) {
                result.update(with: square)
            }

            if abs(tMaxX) < abs(tMaxY) {
                tMaxX += tDeltaX
                x += stepX
            } else {
                tMaxY += tDeltaY
                y += stepY
            }
        }

        return result
    }
}
