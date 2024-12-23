// EmergencyFundView.swift

import SwiftUI

struct EmergencyFundView: View {
    @EnvironmentObject var budgetData: BudgetData
    @State private var emergencyFundGoal: String = ""
    @State private var emergencyFundBalance: String = ""
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

            // Add to Emergency Fund
            VStack(alignment: .leading, spacing: 10) {
                Text("Add to Emergency Fund")
                    .font(.headline)

                TextField("Amount to Add", text: $emergencyFundBalance)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress")
                        .font(.headline)
                    
                    ProgressView(value: budgetData.emergencyFundBalance, total: budgetData.emergencyFundGoal)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .accentColor(.blue)
                    
                    Text(String(format: "%.0f%% of Goal", (budgetData.emergencyFundBalance / budgetData.emergencyFundGoal) * 100))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal);
                
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

            // Set/Update Goal
            VStack(alignment: .leading, spacing: 10) {
                Text("Set/Update Goal")
                    .font(.headline)

                TextField("Goal Amount", text: $emergencyFundGoal)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    setEmergencyFundGoal()
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
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func addToEmergencyFund() {
        guard let amount = Double(emergencyFundBalance), amount > 0 else {
            alertMessage = "Please enter a valid amount."
            showingAlert = true
            return
        }

        budgetData.emergencyFundBalance += amount
        emergencyFundBalance = ""
    }

    func setEmergencyFundGoal() {
        guard let goal = Double(emergencyFundGoal), goal > 0 else {
            alertMessage = "Please enter a valid goal amount."
            showingAlert = true
            return
        }

        budgetData.emergencyFundGoal = goal
        emergencyFundGoal = String(format: "%.2f", goal)
    }
}

struct EmergencyFundView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyFundView()
            .environmentObject(BudgetData())
    }
}
