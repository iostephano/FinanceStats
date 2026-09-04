//
//  FinanceStatsApp.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI

@main
struct FinanceStatsApp: App {
    var body: some Scene {
        WindowGroup {
            StatisticsView()
                .preferredColorScheme(.dark)
        }
    }
}
