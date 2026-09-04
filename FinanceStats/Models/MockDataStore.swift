//
//  MockDataStore.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import Foundation

struct MockDataStore {
    static func month(_ name: String, amounts: [CategoryKind: Decimal]) -> MonthData {
        let categories = CategoryKind.allCases.map { kind in
            ExpenseCategory(kind: kind, amount: amounts[kind] ?? 0)
        }
        return MonthData(monthName: name, categories: categories)
    }

    // MARK: Semana (1..4)
    static let monthsForWeekPeriod: [MonthData] = [
        month("Semana 1", amounts: [.home: 420, .food: 180, .education: 0, .entertainment: 120, .other: 900, .charity: 40, .services: 110, .health: 85, .clothes: 0]),
        month("Semana 2", amounts: [.home: 260, .food: 210, .education: 50, .entertainment: 180, .other: 500, .charity: 0, .services: 90, .health: 60, .clothes: 120]),
        month("Semana 3", amounts: [.home: 300, .food: 140, .education: 0, .entertainment: 95, .other: 430, .charity: 10, .services: 120, .health: 70, .clothes: 40]),
        month("Semana 4", amounts: [.home: 210, .food: 160, .education: 30, .entertainment: 130, .other: 360, .charity: 5, .services: 85, .health: 55, .clothes: 20])
    ]

    // MARK: Mes (12 meses)
    static let monthsForMonthPeriod: [MonthData] = [
        month("Enero", amounts: [.home: 2100, .food: 980, .education: 120, .entertainment: 450, .other: 1800, .charity: 120, .services: 700, .health: 300, .clothes: 160]),
        month("Febrero", amounts: [.home: 1950, .food: 880, .education: 90, .entertainment: 520, .other: 1500, .charity: 110, .services: 640, .health: 280, .clothes: 120]),
        month("Marzo", amounts: [.home: 2200, .food: 1020, .education: 200, .entertainment: 610, .other: 2200, .charity: 140, .services: 760, .health: 420, .clothes: 200]),
        month("Abril", amounts: [.home: 1800, .food: 1100, .education: 150, .entertainment: 530, .other: 1700, .charity: 100, .services: 690, .health: 360, .clothes: 150]),
        month("Mayo", amounts: [.home: 2114, .food: 3107, .education: 0, .entertainment: 884, .other: 3982, .charity: 706, .services: 2290, .health: 816, .clothes: 0]),
        month("Junio", amounts: [.home: 2310, .food: 920, .education: 80, .entertainment: 510, .other: 2100, .charity: 160, .services: 880, .health: 390, .clothes: 140]),
        month("Julio", amounts: [.home: 2500, .food: 1130, .education: 200, .entertainment: 640, .other: 2600, .charity: 200, .services: 900, .health: 500, .clothes: 260]),
        month("Agosto", amounts: [.home: 2840, .food: 1072, .education: 450, .entertainment: 598, .other: 10417, .charity: 351, .services: 820, .health: 785, .clothes: 610]),
        month("Septiembre", amounts: [.home: 2840, .food: 1072, .education: 450, .entertainment: 598, .other: 10417, .charity: 351, .services: 820, .health: 785, .clothes: 610]),
        month("Octubre", amounts: [.home: 1500, .food: 1280, .education: 220, .entertainment: 910, .other: 3210, .charity: 420, .services: 990, .health: 640, .clothes: 300]),
        month("Noviembre", amounts: [.home: 1700, .food: 890, .education: 180, .entertainment: 760, .other: 2500, .charity: 260, .services: 910, .health: 560, .clothes: 280]),
        month("Diciembre", amounts: [.home: 2750, .food: 1450, .education: 220, .entertainment: 980, .other: 2900, .charity: 320, .services: 1040, .health: 620, .clothes: 450])
    ]

    // MARK: Año (2024 y 2025)
    static let monthsForYearPeriod: [MonthData] = [
        month("2024", amounts: [.home: 25000, .food: 12500, .education: 2100, .entertainment: 7200, .other: 26500, .charity: 1900, .services: 9800, .health: 6400, .clothes: 4200]),
        month("2025", amounts: [.home: 9600, .food: 5200, .education: 800, .entertainment: 3100, .other: 10900, .charity: 900, .services: 4200, .health: 2600, .clothes: 1600])
    ]
}
