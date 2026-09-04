//
//  StatisticsView.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

struct StatisticsView: View {
    @State private var vm = StatisticsViewModel()

    private let wheelToRingGap: CGFloat = 16 // carrusel ↔ anillo
    private let ringToLegendGap: CGFloat = 20 // anillo ↔ leyenda

    var body: some View {
        ZStack {
            DS.ColorToken.bgPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                PeriodSelectorView(selection: $vm.selectedPeriod)
                    .padding(.horizontal, 16)
                    .padding(.top, 6)

                MonthScrollView(months: vm.months, index: $vm.selectedIndex) { newIndex in
                    vm.setIndex(newIndex)
                }
                .id(vm.selectedPeriod)
                .padding(.horizontal, 16)

                Spacer(minLength: wheelToRingGap)

                ExpenseRingView(
                    categories: vm.current.categories,
                    total: vm.current.total,
                    progress: vm.ringProgress
                )
                .scaleEffect(vm.amountScale)
                .padding(.horizontal, 20)

                Spacer(minLength: ringToLegendGap)

                ExpenseLegendView(categories: vm.current.categories)
                    .padding(.horizontal, 16)

                Spacer(minLength: 12)
            }
            .foregroundStyle(DS.ColorToken.textPrimary)
        }
    }

    private var topBar: some View {
        HStack {
            Image(systemName: "chevron.left")
            Spacer()
            Text("Estadísticas").font(.headline.weight(.semibold))
            Spacer()
            Image(systemName: "ellipsis")
        }
        .foregroundStyle(DS.ColorToken.textSecondary)
    }
}
