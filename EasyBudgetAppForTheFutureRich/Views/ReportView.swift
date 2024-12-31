import SwiftUI
import Charts

struct ReportView: View {
    @EnvironmentObject var budgetData: BudgetData

    var totalSavings: Double {
        // Calculate total savings from savings buckets and emergency fund deposits
        let savingsBucketsDeposits = budgetData.savingsBuckets.reduce(0) { $0 + $1.depositPerPayPeriod }
        let emergencyFundDeposit = budgetData.emergencyFundBalance
        return savingsBucketsDeposits + emergencyFundDeposit
    }

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

                // Savings Breakdown
                VStack(alignment: .leading, spacing: 10) {
                    Text("Savings Allocation")
                        .font(.headline)
                        .padding(.horizontal)

                    HStack {
                        Text("Savings Buckets Deposits:")
                        Spacer()
                        Text(String(format: "$%.2f", budgetData.savingsBuckets.reduce(0) { $0 + $1.depositPerPayPeriod }))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Emergency Fund Deposits:")
                        Spacer()
                        Text(String(format: "$%.2f", budgetData.emergencyFundBalance))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Total Savings:")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "$%.2f", totalSavings))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

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
