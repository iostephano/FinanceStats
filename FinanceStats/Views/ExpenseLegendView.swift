//
//  ExpenseLegendView.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

struct ExpenseLegendView: View {
    let categories: [ExpenseCategory]
    private let columns = [GridItem(.flexible(), spacing: DS.Space.l), GridItem(.flexible(), spacing: DS.Space.l)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: DS.Space.s) {
            ForEach(categories) { category in
                HStack(spacing: 8) {
                    Dot(color: category.color)
                    Text(category.name)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(DS.ColorToken.textPrimary)
                    Spacer(minLength: 4)
                    Text(category.amount.formattedPlain())
                        .font(.caption.weight(.bold))
                        .monospacedDigit()
                        .foregroundStyle(DS.ColorToken.textSecondary)
                        .frame(minWidth: 60, alignment: .trailing)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(category.name), \(category.amount.formattedPlain()) dólares")
            }
        }
    }
}
