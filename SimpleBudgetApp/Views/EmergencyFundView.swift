// EmergencyFundView.swift

import SwiftUI

struct EmergencyFundView: View {
    @EnvironmentObject var budgetData: BudgetData
    @State private var emergencyFundGoal: String = ""
    @State private var emergencyFundBalance: String = ""
    @State private var payPeriodAmount: String = ""
    @State private var multiplier: String = "3" // Default multiplier
    @State private var isPayPeriodEnabled: Bool = false // Checkbox state
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Emergency Fund")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Current Balance
            HStack {
                Text("Current Balance:")
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f", budgetData.emergencyFundBalance))
                    .font(.headline)
            }
            .padding(.horizontal)

            // Goal Amount
            HStack {
                Text("Goal Amount:")
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f", budgetData.emergencyFundGoal))
                    .font(.headline)
            }
            .padding(.horizontal)

            // Total Non-Discretionary Expenses
            HStack {
                Text("Total Non-Discretionary Expenses:")
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f", totalNonDiscretionaryExpenses))
                    .font(.headline)
            }
            .padding(.horizontal)

            // Add to Emergency Fund
            VStack(alignment: .leading, spacing: 10) {
                Text("Add to Emergency Fund")
                    .font(.headline)

                TextField("Amount to Add", text: $emergencyFundBalance)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    addToEmergencyFund()
                }) {
                    Text("Add Funds")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            // Set Per Pay Period Contribution
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Toggle(isOn: $isPayPeriodEnabled) {
                        Text("Enable Per Pay Period Contribution")
                            .font(.headline)
                    }
                }

                if isPayPeriodEnabled {
                    TextField("Set Per Pay Period Amount", text: $payPeriodAmount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        setPayPeriodAmount()
                    }) {
                        Text("Set Contribution")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }

                if let currentPayPeriodAmount = getPayPeriodAmount() {
                    HStack {
                        Text("Amount: \(currentPayPeriodAmount)")
                            .font(.body)
                            .foregroundColor(.primary)
                            .onTapGesture {
                                addPayPeriodAmount()
                            }
                        Spacer()
                        Text("Tap to add")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            // Set Goal Based on Multiplier
            VStack(alignment: .leading, spacing: 10) {
                Text("Set Goal Based on Non-Discretionary Amount")
                    .font(.headline)

                HStack {
                    TextField("Multiplier", text: $multiplier)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("× \(String(format: "$%.2f", totalNonDiscretionaryExpenses))")
                        .foregroundColor(.primary)
                }

                Button(action: {
                    setGoalBasedOnMultiplier()
                }) {
                    Text("Set Goal")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .onAppear {
            // Initialize state with current data
            emergencyFundGoal = String(format: "%.2f", budgetData.emergencyFundGoal)
            emergencyFundBalance = ""
            isPayPeriodEnabled = UserDefaults.standard.bool(forKey: "isPayPeriodEnabled")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - Computed Properties

    var totalNonDiscretionaryExpenses: Double {
        budgetData.expenses
            .filter { expense in
                budgetData.categories.first(where: { $0.id == expense.categoryID })?.name.lowercased() == "non-discretionary"
            }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: - Functions

    func addToEmergencyFund() {
        guard let amount = Double(emergencyFundBalance), amount > 0 else {
            alertMessage = "Please enter a valid amount."
            showingAlert = true
            return
        }

        budgetData.emergencyFundBalance += amount
        emergencyFundBalance = ""
    }

    func setPayPeriodAmount() {
        guard let amount = Double(payPeriodAmount), amount > 0 else {
            alertMessage = "Please enter a valid per-pay-period amount."
            showingAlert = true
            return
        }

        UserDefaults.standard.set(amount, forKey: "PayPeriodAmount")
        payPeriodAmount = "" // Clear the input field
    }

    func addPayPeriodAmount() {
        guard let amount = getPayPeriodAmountAsDouble(), amount > 0 else {
            alertMessage = "Invalid per-pay-period amount."
            showingAlert = true
            return
        }

        budgetData.emergencyFundBalance += amount
    }

    func setGoalBasedOnMultiplier() {
        guard let multiplierValue = Double(multiplier), multiplierValue > 0 else {
            alertMessage = "Please enter a valid multiplier."
            showingAlert = true
            return
        }

        let calculatedGoal = totalNonDiscretionaryExpenses * multiplierValue
        budgetData.emergencyFundGoal = calculatedGoal
        emergencyFundGoal = String(format: "%.2f", calculatedGoal)
    }

    func getPayPeriodAmount() -> String? {
        guard let amount = UserDefaults.standard.value(forKey: "PayPeriodAmount") as? Double else {
            return nil
        }
        return String(format: "$%.2f", amount)
    }

    func getPayPeriodAmountAsDouble() -> Double? {
        return UserDefaults.standard.value(forKey: "PayPeriodAmount") as? Double
    }
}
