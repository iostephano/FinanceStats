//
//  Components.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

struct Pill: View {
    let title: String
    let selected: Bool

    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(selected ? .black : DS.ColorToken.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(selected ? .white : DS.ColorToken.bgCard))
            .overlay(Capsule().stroke(DS.ColorToken.border, lineWidth: DS.Stroke.thin))
            .animation(.easeInOut(duration: 0.2), value: selected)
    }
}

struct Dot: View {
    let color: Color

    var body: some View {
        Circle().fill(color).frame(width: 8, height: 8)
    }
}
