import SwiftUI

@main
struct EasyBudgetAppForTheFutureRichApp: App {
    @StateObject private var budgetData = BudgetData()
    @State private var showWelcomeVideo = true

    var body: some Scene {
        WindowGroup {
            if showWelcomeVideo {
                WelcomeVideoView(showWelcomeVideo: $showWelcomeVideo)
                    .environmentObject(budgetData)
            } else {
                ContentView()
                    .environmentObject(budgetData)
            }
        }
    }
}

