// ReportView.swift

import SwiftUI
import Charts

struct ReportView: View {
    @EnvironmentObject var budgetData: BudgetData

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Title
                Text("Budget Report")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Pie Chart Representation
                PieChartView(budgetData: budgetData)
                    .frame(height: 300)
                    .padding()

                // Bar Chart Representation
                BarChartView(budgetData: budgetData)
                    .frame(height: 300)
                    .padding()

                // Category-wise Expense Breakdown
                CategoryExpenseBreakdownView(budgetData: _budgetData)
                    .padding()

                // Recommended Ratios
                RecommendedRatiosView()
                
                // Emergency Fund Button
                NavigationLink(destination: EmergencyFundView()) {
                    Text("Manage Emergency Fund")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)                

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Report")
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
            .environmentObject(BudgetData())
    }
}

// MARK: - PieChartView

struct PieChartView: View {
    var budgetData: BudgetData

    var body: some View {
        if budgetData.grossIncome > 0 {
            Chart {
                ForEach(budgetData.categories) { category in
                    SectorMark(
                        angle: .value("Amount", totalAmount(for: category)),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(Color(hex: category.colorHex) ?? .gray)
                    .annotation(position: .overlay) { // Correct Alignment
                        Text(category.name)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .chartLegend(.hidden)
            .chartBackground(alignment: .center) { _ in // Valid Alignment
                Color(.systemBackground) // Background color
            }
            .accessibilityLabel("Pie chart showing distribution of expenses by category.")
        } else {
            Text("Gross Income is zero. Please set your income to view the chart.")
                .foregroundColor(.gray)
                .padding()
        }
    }

    func totalAmount(for category: Category) -> Double {
        budgetData.expenses.filter { $0.categoryID == category.id }.reduce(0) { $0 + $1.amount }
    }
}

// MARK: - BarChartView

struct BarChartView: View {
    var budgetData: BudgetData

    var body: some View {
        Chart {
            ForEach(budgetData.categories) { category in
                BarMark(
                    x: .value("Category", category.name),
                    y: .value("Amount", totalAmount(for: category))
                )
                .foregroundStyle(Color(hex: category.colorHex) ?? .gray)
                .annotation(position: .top) { // Correct Alignment
                    Text(String(format: "$%.2f", totalAmount(for: category)))
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: budgetData.categories.map { $0.name })
        }
        .chartBackground(alignment: .center) { _ in // Use a valid Alignment
            Color(.systemBackground) // Set the background color within the closure
        }
        .accessibilityLabel("Bar chart showing expenses by category.")
    }

    func totalAmount(for category: Category) -> Double {
        budgetData.expenses.filter { $0.categoryID == category.id }.reduce(0) { $0 + $1.amount }
    }
}
