import SwiftUI
import Charts

struct SnowballPlanChartView: View {
    var plan: [DebtPlan]

    var body: some View {
        Chart {
            ForEach(plan, id: \.debt.id) { plan in
                BarMark(
                    x: .value("Debt", plan.debt.name),
                    y: .value("Total Paid", plan.totalPaid)
                )
                .foregroundStyle(by: .value("Debt", plan.debt.name))
            }
        }
        .chartLegend(.visible)
        .frame(height: 300)
    }
}
