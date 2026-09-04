//
//  StatisticsViewModel.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

@MainActor
@Observable
final class StatisticsViewModel {
    var selectedPeriod: Period = .month { didSet { loadData() } }
    var selectedIndex: Int = 0 { didSet { animateUpdate() } }

    private(set) var months: [MonthData] = []
    private(set) var current: MonthData = MockDataStore.monthsForMonthPeriod[0]
    var ringProgress: CGFloat = 0
    var amountScale: CGFloat = 1

    init() { loadData() }

    func loadData() {
        switch selectedPeriod {
        case .week: months = MockDataStore.monthsForWeekPeriod
        case .month: months = MockDataStore.monthsForMonthPeriod
        case .year: months = MockDataStore.monthsForYearPeriod
        }
        selectedIndex = 0
        current = months[0]
        animateIntro()
    }

    func setIndex(_ index: Int) {
        guard months.indices.contains(index) else { return }
        selectedIndex = index
        current = months[index]
    }

    private func animateIntro() {
        ringProgress = 0
        withAnimation(.easeOut(duration: 0.9)) { ringProgress = 1 }
        amountPulse()
    }

    private func animateUpdate() {
        ringProgress = 0
        withAnimation(.easeInOut(duration: 0.8)) { ringProgress = 1 }
        amountPulse()
    }

    private func amountPulse() {
        withAnimation(.interpolatingSpring(stiffness: 220, damping: 18)) { amountScale = 1.06 }
        Task {
            try? await Task.sleep(for: .seconds(0.18))
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { amountScale = 1.0 }
        }
    }
}
