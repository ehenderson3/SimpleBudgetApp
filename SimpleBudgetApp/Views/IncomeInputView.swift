import SwiftUI

struct IncomeInputView: View {
    @EnvironmentObject var budgetData: BudgetData
    @State private var incomeInput: String = ""
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToNext: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Your Monthly Income")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            TextField("Enter income (e.g., 5000)", text: $incomeInput)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if let currentIncome = getCurrentIncome() {
                Text("Current Monthly Income: \(currentIncome)")
                    .foregroundColor(.gray)
                    .font(.body)
            }

            NavigationLink(
                destination: ExpenseInputView(expenseType: .nonDiscretionary),
                isActive: $navigateToNext
            ) {
                EmptyView()
            }

            Button(action: saveIncomeAndNavigate) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValidIncome() ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isValidIncome())

            Spacer()
        }
        .padding()
        .onAppear {
            loadCurrentIncome()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Input"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }

    func isValidIncome() -> Bool {
        guard let income = Double(incomeInput), income > 0 else {
            return false
        }
        return true
    }

    func saveIncomeAndNavigate() {
        guard let income = Double(incomeInput), income > 0 else {
            alertMessage = "Please enter a valid positive income amount."
            showingAlert = true
            return
        }
        budgetData.grossIncome = income // Update the budget data
        navigateToNext = true // Trigger navigation
    }

    func loadCurrentIncome() {
        // Prepopulate the input field with the current income, if any
        if budgetData.grossIncome > 0 {
            incomeInput = String(format: "%.2f", budgetData.grossIncome)
        }
    }

    func getCurrentIncome() -> String? {
        // Return the formatted current income, or nil if no income is set
        return budgetData.grossIncome > 0 ? String(format: "$%.2f", budgetData.grossIncome) : nil
    }
}
