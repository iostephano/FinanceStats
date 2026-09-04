//
//  DesignSystem.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

enum DS {
    enum ColorToken {
        static let bgPrimary = Color(hex: "#1E1E1F")
        static let bgCard = Color(hex: "#262628")
        static let textPrimary = Color(hex: "#F2F2F3")
        static let textSecondary = Color(hex: "#A7A7AD")
        static let border = Color(hex: "#3A3A3D").opacity(0.6)

        static let home = Color(hex: "#8CC8FF")
        static let food = Color(hex: "#FFA866")
        static let education = Color(hex: "#5F79FF")
        static let entertainment = Color(hex: "#A983FF")
        static let other = Color(hex: "#7E7E82")
        static let charity = Color(hex: "#1E3A8A")
        static let services = Color(hex: "#E5F173")
        static let health = Color(hex: "#8AF27D")
        static let clothes = Color(hex: "#FF5B5B")
    }

    enum Radius {
        static let pill: CGFloat = 16
        static let button: CGFloat = 20
    }

    enum Space {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
    }

    enum Stroke {
        static let thin: CGFloat = 1
    }

    enum Ring {
        static let diameter: CGFloat = 260
        static let lineWidth: CGFloat = 28
    }
}

// MARK: - Utilities

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
