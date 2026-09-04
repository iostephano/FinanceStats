//
//  Money.swift
//  FinanceStats
//
//  Created by Stephano Portella on 04/09/25.
//

import Foundation

extension Decimal {
    // Monto compacto para el centro del anillo: a partir de mil se abrevia ("$1.2K"),
    // si no se muestra el entero. Locale fijo para no depender de la configuración del
    // dispositivo (una coma decimal ahí rompería el "$X.XK").
    func formattedCompact() -> String {
        let magnitude = self < 0 ? -self : self
        guard magnitude >= 1000 else { return formattedPlain() }

        let thousands = self / 1000
        let value = thousands.formatted(
            .number.locale(Locale(identifier: "en_US")).precision(.fractionLength(1))
        )
        return "$" + value + "K"
    }

    // Monto sin abreviar ni separador de miles, igual que el diseño original de la leyenda.
    func formattedPlain() -> String {
        let value = formatted(
            .number.locale(Locale(identifier: "en_US")).precision(.fractionLength(0)).grouping(.never)
        )
        return "$" + value
    }

    // Puente a Double solo para geometría en pantalla (ángulos del anillo), nunca para
    // un cálculo monetario.
    var asDouble: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}
