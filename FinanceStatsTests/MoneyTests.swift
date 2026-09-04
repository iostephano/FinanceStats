//
//  MoneyTests.swift
//  FinanceStatsTests
//
//  Created by Stephano Portella on 04/09/25.
//

import Testing
import Foundation
@testable import FinanceStats

struct MoneyTests {
    @Test("Amounts under a thousand are shown as plain dollars")
    func smallAmountsAreNotAbbreviated() {
        #expect(Decimal(450).formattedCompact() == "$450")
    }

    @Test("Amounts of a thousand or more are abbreviated with K")
    func largeAmountsAreAbbreviated() {
        #expect(Decimal(56502).formattedCompact() == "$56.5K")
        #expect(Decimal(1000).formattedCompact() == "$1.0K")
    }

    @Test("Plain formatting never groups thousands")
    func plainFormattingHasNoGrouping() {
        #expect(Decimal(10417).formattedPlain() == "$10417")
    }
}
