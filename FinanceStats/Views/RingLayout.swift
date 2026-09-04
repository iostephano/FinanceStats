//
//  RingLayout.swift
//  FinanceStats
//
//  Created by Stephano Portella on 04/09/25.
//

import CoreGraphics
import Foundation

// Geometría pura del anillo de gastos, separada de la vista para poder cubrirla con
// pruebas sin tocar SwiftUI. Antes vivía como método privado de ExpenseRingView.
enum RingLayout {
    struct Segment: Equatable {
        let start: CGFloat
        let length: CGFloat
    }

    /// Calcula (start, length) por cada monto, en fracciones de vuelta completa (0...1), garantizando:
    /// - Gaps con tamaño **visible** constante, corrigiendo la invasión de los caps redondeados.
    /// - Todo monto > 0 aparece con un mínimo angular.
    /// - Renormaliza para que ∑lengths + ∑gaps = 1.0 (anillo completo).
    static func segments(
        amounts: [Decimal],
        total: Decimal,
        lineWidth: CGFloat,
        diameter: CGFloat,
        gapVisibleDegrees: Double = 2.0,
        minDegrees: Double = 3.0
    ) -> [Segment] {
        guard !amounts.isEmpty, diameter > 0 else { return [] }
        let n = amounts.count

        // Caps: cada píldora "crece" ~ lineWidth/(π*diameter) (suma de ambos extremos).
        let capF = lineWidth / (.pi * diameter)

        // Gap objetivo visible + compensación por caps.
        let gapVisibleF = CGFloat(gapVisibleDegrees / 360.0)
        let gapF = gapVisibleF + capF

        // Fracción disponible para color, descontando gaps.
        let usable = max(0, 1 - gapF * CGFloat(n))

        // Pesos por monto.
        let sum = max(total.asDouble, 0.0001)
        var lengths = amounts.map { CGFloat($0.asDouble / sum) * usable }

        // Mínimo angular.
        let minF = CGFloat(minDegrees / 360.0)
        for i in lengths.indices { lengths[i] = max(lengths[i], minF) }

        // Renormalizar para que ∑lengths == usable.
        let currentSum = lengths.reduce(0, +)
        if currentSum > 0 {
            let scale = usable / currentSum
            for i in lengths.indices { lengths[i] *= scale }
        }

        var result: [Segment] = []
        var cursor: CGFloat = 0
        for length in lengths {
            let start = cursor + gapF * 0.5
            result.append(Segment(start: start, length: length))
            cursor += length + gapF
        }
        return result
    }
}
