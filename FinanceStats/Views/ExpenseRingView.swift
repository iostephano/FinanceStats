//
//  ExpenseRingView.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

struct ExpenseRingView: View {
    let categories: [ExpenseCategory]
    let total: Decimal
    let progress: CGFloat // 0…1 (animación)

    private let lineWidth: CGFloat = DS.Ring.lineWidth
    private let diameter: CGFloat = DS.Ring.diameter

    var body: some View {
        ZStack {
            ringSegments
            totalView
        }
        .frame(height: diameter)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Total de gasto \(total.formattedCompact())")
    }

    // MARK: - Segmentos

    private var ringSegments: some View {
        let active = categories.filter { $0.amount > 0 }
        let segments = RingLayout.segments(
            amounts: active.map(\.amount),
            total: total,
            lineWidth: lineWidth,
            diameter: diameter
        )

        return ZStack {
            ForEach(Array(zip(active, segments)), id: \.0.id) { category, segment in
                Circle()
                    .trim(from: segment.start, to: segment.start + (segment.length * max(0, progress)))
                    .stroke(category.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: diameter, height: diameter)
                    .accessibilityLabel("\(category.name) \(category.amount.formattedPlain())")
            }
        }
    }

    // MARK: - Total

    private var totalView: some View {
        VStack(spacing: 6) {
            Text(total.formattedCompact())
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .minimumScaleFactor(0.6)
            Text("Total")
                .font(.footnote)
                .foregroundStyle(DS.ColorToken.textSecondary)
        }
        .foregroundStyle(DS.ColorToken.textPrimary)
    }
}
