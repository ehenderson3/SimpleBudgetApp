// SimpleBudgetAppApp.swift

import SwiftUI

@main
struct SimpleBudgetAppApp: App {
    @StateObject private var budgetData = BudgetData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(budgetData)
        }
    }
}
