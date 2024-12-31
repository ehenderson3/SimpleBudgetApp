// CategoryExpenseBreakdownView.swift

import SwiftUI

struct CategoryExpenseBreakdownView: View {
    @EnvironmentObject var budgetData: BudgetData

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

struct CategoryExpenseBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryExpenseBreakdownView()
            .environmentObject(BudgetData())
    }
}
