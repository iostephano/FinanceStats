//
//  CategoryKind.swift
//  FinanceStats
//
//  Created by Stephano Portella on 04/09/25.
//

import SwiftUI

// Catálogo cerrado de categorías de gasto. Antes el nombre venía como String suelto
// (categoriesOrder) y no coincidía con las claves de los diccionarios de montos —
// una categoría entera se perdía en silencio. Con un enum el compilador lo impide.
enum CategoryKind: CaseIterable {
    case home, food, education, entertainment, other, charity, services, health, clothes

    var displayName: String {
        switch self {
        case .home: "Casa"
        case .food: "Comida"
        case .education: "Educación"
        case .entertainment: "Entretenimiento"
        case .other: "Otros"
        case .charity: "Caridad"
        case .services: "Servicios"
        case .health: "Salud"
        case .clothes: "Ropa"
        }
    }

    var color: Color {
        switch self {
        case .home: DS.ColorToken.home
        case .food: DS.ColorToken.food
        case .education: DS.ColorToken.education
        case .entertainment: DS.ColorToken.entertainment
        case .other: DS.ColorToken.other
        case .charity: DS.ColorToken.charity
        case .services: DS.ColorToken.services
        case .health: DS.ColorToken.health
        case .clothes: DS.ColorToken.clothes
        }
    }
}
