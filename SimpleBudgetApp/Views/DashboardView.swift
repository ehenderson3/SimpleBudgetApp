import SwiftUI

struct DashboardView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    DashboardButton(title: "Income", icon: "arrow.up.circle.fill", destination: .incomeInput)
                    DashboardButton(title: "Non-Discretionary Expenses", icon: "dollarsign.circle.fill", destination: .expenseInput(.nonDiscretionary))
                    DashboardButton(title: "Discretionary Expenses", icon: "cart.fill", destination: .expenseInput(.discretionary))
                    DashboardButton(title: "Emergency Fund", icon: "shield.fill", destination: .emergencyFund)
                    DashboardButton(title: "Summary", icon: "list.bullet.rectangle", destination: .summary)
                    DashboardButton(title: "Savings Buckets", icon: "folder.fill", destination: .savingsBuckets)
                    DashboardButton(title: "Snowball", icon: "snowflake", destination: .snowball)
                    DashboardButton(title: "Report", icon: "chart.pie.fill", destination: .report)


                }
                .padding()
            }
            .navigationDestination(for: BudgetDestination.self) { destination in
                switch destination {
                case .incomeInput:
                    IncomeInputView()
                case .expenseInput(let type):
                    ExpenseInputView(expenseType: type) // Pass the expense type to ExpenseInputView
                        //.environmentObject(BudgetData())
                case .summary:
                    SummaryView()
                case .report:
                    ReportView()
                case .emergencyFund:
                    EmergencyFundView()
                case .snowball:
                    SnowballView()
                case .savingsBuckets:
                    SavingsBucketView()
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}
