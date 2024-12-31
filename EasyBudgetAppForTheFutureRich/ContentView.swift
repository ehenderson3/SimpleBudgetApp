// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var destination: BudgetDestination?
    
    var body: some View {
        NavigationStack {
            DashboardView()
                .navigationDestination(for: BudgetDestination.self) { destination in
                    switch destination {
                    case .expenseInput(let type):
                        if type == .nonDiscretionary {
                            NonDiscretionaryExpensesView()
                        } else {
                            DiscretionaryExpensesView()
                        }
                    case .summary:
                        SummaryView()
                            .environmentObject(BudgetData())
                    case .incomeInput:
                        IncomeInputView()
                            .environmentObject(BudgetData())
                    case .report:
                        ReportView()
                            .environmentObject(BudgetData())
                    case .emergencyFund:
                        EmergencyFundView()
                            .environmentObject(BudgetData())
                    case .snowball:
                        SnowballView()
                            .environmentObject(BudgetData())
                    case .savingsBuckets:
                        SavingsBucketView()
                            .environmentObject(BudgetData())
                        
                    }
                }
        }
    }
    
    struct NonDiscretionaryExpensesView: View {
        var body: some View {
            Text("Non-Discretionary Expenses")
                .font(.largeTitle)
                .padding()
        }
    }
    
    struct DiscretionaryExpensesView: View {
        var body: some View {
            Text("Discretionary Expenses")
                .font(.largeTitle)
                .padding()
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(BudgetData())
        }
    }
}
