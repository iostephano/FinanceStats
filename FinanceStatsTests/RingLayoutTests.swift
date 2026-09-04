//
//  RingLayoutTests.swift
//  FinanceStatsTests
//
//  Created by Stephano Portella on 04/09/25.
//

import Testing
import Foundation
@testable import FinanceStats

struct RingLayoutTests {
    private let lineWidth: CGFloat = 28
    private let diameter: CGFloat = 260

    @Test("Segment lengths plus gaps fill the ring")
    func segmentsFillTheRing() {
        let amounts: [Decimal] = [420, 180, 120, 900]
        let segments = RingLayout.segments(
            amounts: amounts,
            total: amounts.reduce(0, +),
            lineWidth: lineWidth,
            diameter: diameter
        )
        #expect(segments.count == amounts.count)

        let lastEnd = segments.last!.start + segments.last!.length
        #expect(lastEnd <= 1.01)
        #expect(lastEnd > 0.9)
    }

    @Test("Every positive amount gets at least the minimum angular length")
    func smallAmountsGetAMinimumSize() {
        // Un monto casi cero frente a otros grandes no debería desaparecer del anillo.
        let amounts: [Decimal] = [1, 10000, 10000]
        let segments = RingLayout.segments(
            amounts: amounts,
            total: amounts.reduce(0, +),
            lineWidth: lineWidth,
            diameter: diameter,
            minDegrees: 3.0
        )
        let minFraction = CGFloat(3.0 / 360.0)
        #expect(segments[0].length >= minFraction * 0.99)
    }

    @Test("An empty amount list produces no segments")
    func emptyAmountsProduceNoSegments() {
        let segments = RingLayout.segments(amounts: [], total: 0, lineWidth: lineWidth, diameter: diameter)
        #expect(segments.isEmpty)
    }

    @Test("A zero total does not crash or produce NaN")
    func zeroTotalIsHandledSafely() {
        let segments = RingLayout.segments(amounts: [0, 0], total: 0, lineWidth: lineWidth, diameter: diameter)
        #expect(segments.count == 2)
        for segment in segments {
            #expect(!segment.start.isNaN)
            #expect(!segment.length.isNaN)
        }
    }
}
