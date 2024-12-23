import SwiftUI

struct SnowballView: View {
    @State private var debts: [Debt] = []
    @State private var extraPayment: String = ""
    @State private var snowballPlan: [DebtPlan] = []
    @State private var showingAddDebtModal: Bool = false // Control modal presentation
    
    private let calculator = SnowballCalculator()

    var body: some View {
        VStack(spacing: 20) {
            Text("Debt Snowball Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // List of debts
            List {
                ForEach(debts) { debt in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(debt.name)
                                .font(.headline)
                            Text(String(format: "Balance: $%.2f", debt.balance))
                            Text(String(format: "Interest: %.2f%%", debt.interestRate))
                            Text(String(format: "Minimum Payment: $%.2f", debt.minimumPayment))
                        }
                        Spacer()
                        Button(action: {
                            removeDebt(debt)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            // Button to add new debt
            Button(action: {
                showingAddDebtModal = true
            }) {
                Text("Add Debt")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingAddDebtModal) {
                AddDebtView { newDebt in
                    debts.append(newDebt)
                }
            }

            // Extra payment field
            TextField("Extra Payment (Optional)", text: $extraPayment)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Calculate snowball plan
            Button(action: calculatePlan) {
                Text("Calculate Snowball Plan")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(debts.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(debts.isEmpty)
            .padding(.horizontal)

            // Show snowball plan
            if !snowballPlan.isEmpty {
                List {
                    ForEach(snowballPlan, id: \.debt.id) { plan in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(plan.debt.name)
                                .font(.headline)
                            Text(String(format: "Total Paid: $%.2f", plan.totalPaid))
                            Text("Months to Pay Off: \(plan.monthsToPayOff)")
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    func removeDebt(_ debt: Debt) {
        if let index = debts.firstIndex(where: { $0.id == debt.id }) {
            debts.remove(at: index)
        }
    }

    func calculatePlan() {
        let extra = Double(extraPayment) ?? 0.0
        snowballPlan = calculator.calculate(debts: debts, extraPayment: extra)
    }
}
