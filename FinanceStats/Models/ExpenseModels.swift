//
//  ExpenseModels.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

enum Period: String, CaseIterable, Identifiable {
    case week = "Semana"
    case month = "Mes"
    case year = "Año"

    var id: String { rawValue }
}

struct ExpenseCategory: Identifiable, Hashable {
    let id = UUID()
    let kind: CategoryKind
    // Importe de gasto: siempre Decimal, nunca Double, para no arrastrar error binario.
    let amount: Decimal

    var name: String { kind.displayName }
    var color: Color { kind.color }
}

struct MonthData: Identifiable {
    let id = UUID()
    let monthName: String
    let categories: [ExpenseCategory]
    var total: Decimal { categories.reduce(0) { $0 + $1.amount } }
}
