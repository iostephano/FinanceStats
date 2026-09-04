//
//  MockDataStoreTests.swift
//  FinanceStatsTests
//
//  Created by Stephano Portella on 04/09/25.
//

import Testing
import Foundation
@testable import FinanceStats

struct MockDataStoreTests {
    @Test("Every month carries one entry per category, in catalog order")
    func monthHasAllCategoriesInOrder() {
        for month in MockDataStore.monthsForMonthPeriod {
            #expect(month.categories.map(\.kind) == CategoryKind.allCases)
        }
    }

    @Test("No category amount is silently dropped from the total")
    func totalIncludesEveryCategory() {
        let january = MockDataStore.monthsForMonthPeriod[0]
        let expected = january.categories.reduce(Decimal(0)) { $0 + $1.amount }
        #expect(january.total == expected)

        let entertainment = january.categories.first { $0.kind == .entertainment }
        #expect(entertainment?.amount == 450)
        #expect(january.total >= 450)
    }

    @Test("Week, month and year periods all provide data")
    func everyPeriodHasData() {
        #expect(MockDataStore.monthsForWeekPeriod.count == 4)
        #expect(MockDataStore.monthsForMonthPeriod.count == 12)
        #expect(MockDataStore.monthsForYearPeriod.count == 2)
    }
}
