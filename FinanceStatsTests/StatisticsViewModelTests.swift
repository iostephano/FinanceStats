//
//  StatisticsViewModelTests.swift
//  FinanceStatsTests
//
//  Created by Stephano Portella on 04/09/25.
//

import Testing
import Foundation
@testable import FinanceStats

@MainActor
struct StatisticsViewModelTests {
    @Test("Starts on the month period with the first month selected")
    func startsOnMonthPeriod() {
        let vm = StatisticsViewModel()
        #expect(vm.selectedPeriod == .month)
        #expect(vm.selectedIndex == 0)
        #expect(vm.current.monthName == MockDataStore.monthsForMonthPeriod[0].monthName)
    }

    @Test("Switching period reloads the months and resets the selection")
    func switchingPeriodReloadsMonths() {
        let vm = StatisticsViewModel()
        vm.setIndex(3)
        vm.selectedPeriod = .week

        #expect(vm.months.count == MockDataStore.monthsForWeekPeriod.count)
        #expect(vm.selectedIndex == 0)
        #expect(vm.current.monthName == MockDataStore.monthsForWeekPeriod[0].monthName)
    }

    @Test("setIndex updates the current month within bounds")
    func setIndexUpdatesCurrentMonth() {
        let vm = StatisticsViewModel()
        vm.setIndex(2)
        #expect(vm.selectedIndex == 2)
        #expect(vm.current.monthName == MockDataStore.monthsForMonthPeriod[2].monthName)
    }

    @Test("setIndex ignores an out-of-range index")
    func setIndexIgnoresOutOfRange() {
        let vm = StatisticsViewModel()
        vm.setIndex(2)
        vm.setIndex(999)
        #expect(vm.selectedIndex == 2)
    }
}
