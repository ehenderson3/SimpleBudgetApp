import SwiftUI
import Charts

struct SnowballView: View {
    @EnvironmentObject var budgetData: BudgetData
    @State private var debts: [Debt] = []
    @State private var extraPayment: String = ""
    @State private var snowballPlan: [DebtPlan] = []
    @State private var showingAddDebtModal: Bool = false
    @State private var showingEditDebtModal: Bool = false
    @State private var selectedDebtIndex: Int?
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false

    private let calculator = SnowballCalculator()

    var remainingAfterExtraPayment: Double {
        budgetData.remainingIncome - (Double(extraPayment) ?? 0)
    }
    

    var body: some View {
        VStack(spacing: 20) {
            Text("Debt Snowball Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text(String(format: "Remaining Income: $%.2f", budgetData.remainingIncome))
                .font(.headline)

            TextField("Extra Payment (Optional)", text: $extraPayment)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Text(String(format: "Remaining After Extra Payment: $%.2f", remainingAfterExtraPayment))
                .font(.subheadline)
                .foregroundColor(remainingAfterExtraPayment >= 0 ? .green : .red)

            List {
                if debts.isEmpty {
                    Text("No debts yet. Add one to get started.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
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
                                if let index = debts.firstIndex(where: { $0.id == debt.id }) {
                                    selectedDebtIndex = index
                                    showingEditDebtModal = true
                                }
                            }) {
                                Text("Edit")
                                    .font(.subheadline)
                                    .padding(8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                removeDebt(debt)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }

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
                    addDebt(newDebt)
                }
            }
            .sheet(isPresented: $showingEditDebtModal) {
                if let selectedDebtIndex = selectedDebtIndex {
                    EditDebtView(debt: $debts[selectedDebtIndex])
                }
            }

            Button(action: calculatePlan) {
                Text("Calculate Snowball Plan")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(debts.isEmpty || remainingAfterExtraPayment < 0 ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(debts.isEmpty || remainingAfterExtraPayment < 0)
            .padding(.horizontal)

            if !snowballPlan.isEmpty {
                SnowballPlanChartView(plan: snowballPlan)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .onAppear {
            loadDebts()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Input"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }

    func addDebt(_ newDebt: Debt) {
        debts.append(newDebt)
        budgetData.debts = debts
    }

    func removeDebt(_ debt: Debt) {
        if let index = debts.firstIndex(where: { $0.id == debt.id }) {
            debts.remove(at: index)
            budgetData.debts = debts
        }
    }

    func loadDebts() {
        debts = budgetData.debts
    }

    func calculatePlan() {
        guard let extra = Double(extraPayment), extra >= 0 else {
            alertMessage = "Please enter a valid positive amount for Extra Payment."
            showingAlert = true
            return
        }

        if remainingAfterExtraPayment < 0 {
            alertMessage = "Insufficient remaining income for this extra payment."
            showingAlert = true
            return
        }

        // Deduct the extra payment by adding it as a new "Extra Payment" expense
        let extraExpense = Expense(name: "Extra Payment", amount: extra, categoryID: UUID())
        budgetData.addExpense(extraExpense)

        extraPayment = "" // Clear the extra payment field

        // Calculate the snowball plan
        snowballPlan = calculator.calculate(debts: debts, extraPayment: extra)
    }
}
