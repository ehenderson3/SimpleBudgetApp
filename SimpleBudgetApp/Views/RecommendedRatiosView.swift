// RecommendedRatiosView.swift

import SwiftUI

struct RecommendedRatiosView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recommended Ratios")
                .font(.headline)

            VStack(alignment: .leading, spacing: 10) {
                Text("Non-Discretionary Expenses:")
                    .font(.subheadline)
                Text("Housing, Utilities, Transportation, Groceries, Insurance, Minimum Debt Payments")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("Recommended: ≤ 50% of income")
                    .font(.footnote)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 10) {
                Text("Discretionary Expenses:")
                    .font(.subheadline)
                Text("Entertainment, Dining Out, Hobbies, Vacations")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("Recommended: ≤ 30% of income")
                    .font(.footnote)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 10) {
                Text("Savings/Remaining:")
                    .font(.subheadline)
                Text("Emergency Fund, Retirement, Additional Debt Payments")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("Recommended: ≥ 20% of income")
                    .font(.footnote)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
        .padding([.horizontal, .bottom])
    }
}

struct RecommendedRatiosView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedRatiosView()
    }
}
