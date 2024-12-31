import SwiftUI
import Charts

struct PieChartView: View {
    var budgetData: BudgetData

    var body: some View {
        Chart {
            // Regular categories
            ForEach(budgetData.categories) { category in
                SectorMark(
                    angle: .value("Amount", totalAmount(for: category)),
                    innerRadius: .ratio(0.5),
                    angularInset: 1
                )
                .foregroundStyle(Color(hex: category.colorHex) ?? .gray)
                .annotation(position: .overlay) {
                    Text(category.name)
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }

            // Add savings as a separate slice
            SectorMark(
                angle: .value("Amount", totalSavings),
                innerRadius: .ratio(0.5),
                angularInset: 1
            )
            .foregroundStyle(Color.green)
            .annotation(position: .overlay) {
                Text("Savings")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .chartLegend(.hidden)
        .padding()
        .accessibilityLabel("Pie chart showing distribution of expenses by category, including savings.")
    }

    func totalAmount(for category: Category) -> Double {
        budgetData.expenses.filter { $0.categoryID == category.id }.reduce(0) { $0 + $1.amount }
    }

    var totalSavings: Double {
        budgetData.savingsBuckets.reduce(0) { $0 + $1.depositPerPayPeriod } + budgetData.emergencyFundBalance
    }
}

struct BarChartView: View {
    var budgetData: BudgetData

    var body: some View {
        Chart {
            // Regular categories
            ForEach(budgetData.categories) { category in
                BarMark(
                    x: .value("Category", category.name),
                    y: .value("Amount", totalAmount(for: category))
                )
                .foregroundStyle(Color(hex: category.colorHex) ?? .gray)
                .annotation(position: .top) {
                    Text(String(format: "$%.2f", totalAmount(for: category)))
                        .font(.caption)
                }
            }

            // Add savings as a separate bar
            BarMark(
                x: .value("Category", "Savings"),
                y: .value("Amount", totalSavings)
            )
            .foregroundStyle(Color.green)
            .annotation(position: .top) {
                Text(String(format: "$%.2f", totalSavings))
                    .font(.caption)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: budgetData.categories.map { $0.name } + ["Savings"])
        }
        .padding()
        .accessibilityLabel("Bar chart showing expenses by category, including savings.")
    }

    func totalAmount(for category: Category) -> Double {
        budgetData.expenses.filter { $0.categoryID == category.id }.reduce(0) { $0 + $1.amount }
    }

    var totalSavings: Double {
        budgetData.savingsBuckets.reduce(0) { $0 + $1.depositPerPayPeriod } + budgetData.emergencyFundBalance
    }
}
