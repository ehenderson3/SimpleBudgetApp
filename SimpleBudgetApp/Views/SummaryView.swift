// SummaryView.swift

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var budgetData: BudgetData

    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("Budget Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Summary Details
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Gross Income:")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "$%.2f", budgetData.grossIncome))
                        .font(.headline)
                }

                HStack {
                    Text("Total Expenses:")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "$%.2f", budgetData.totalExpenses))
                        .font(.headline)
                }

                HStack {
                    Text("Remaining Income:")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "$%.2f", budgetData.remainingIncome))
                        .font(.headline)
                        .foregroundColor(budgetData.remainingIncome >= 0 ? .green : .red)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding([.horizontal, .bottom])

            // Category-wise Summary
            CategoryExpenseSummaryView(budgetData: budgetData)
                .padding()

            // Navigation to ReportView
            NavigationLink(destination: ReportView()
                            .environmentObject(budgetData)) {
                Text("View Report")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canViewReport() ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!canViewReport())
            .padding([.horizontal, .bottom])
        }
        .padding()
        .navigationTitle("Summary")
    }

    func canViewReport() -> Bool {
        // Ensure there's at least one expense and gross income is greater than zero
        return budgetData.grossIncome > 0 && !budgetData.expenses.isEmpty
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environmentObject(BudgetData())
    }
}

// MARK: - CategoryExpenseSummaryView

struct CategoryExpenseSummaryView: View {
    var budgetData: BudgetData

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Expenses by Category")
                .font(.headline)

            ForEach(budgetData.categories) { category in
                HStack {
                    Circle()
                        .fill(Color(hex: category.colorHex) ?? .gray)
                        .frame(width: 15, height: 15)
                    Text(category.name)
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "$%.2f", totalAmount(for: category)))
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    func totalAmount(for category: Category) -> Double {
        budgetData.expenses.filter { $0.categoryID == category.id }.reduce(0) { $0 + $1.amount }
    }
}
