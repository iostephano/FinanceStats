//
//  PeriodSelectorView.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

struct PeriodSelectorView: View {
    @Binding var selection: Period

    var body: some View {
        HStack(spacing: DS.Space.s) {
            ForEach(Period.allCases) { period in
                Button { selection = period } label: {
                    Pill(title: period.rawValue, selected: selection == period)
                }
                .accessibilityLabel("Seleccionar \(period.rawValue)")
            }
        }
    }
}
