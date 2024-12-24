// ExpenseInputView.swift

import SwiftUI

struct ExpenseInputView: View {
    @EnvironmentObject var budgetData: BudgetData
    var expenseType: ExpenseType
    @State private var expenseName: String = ""
    @State private var expenseAmountString: String = ""
    @State private var selectedCategoryID: UUID? // Selected category ID
    @State private var showingCategoryManagement = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Remaining Income: \(String(format: "$%.2f", budgetData.remainingIncome))")
                    .font(.subheadline)
                    .foregroundColor(budgetData.remainingIncome >= 0 ? .green : .red)
                    .padding(.bottom)
                Text(expenseType == .nonDiscretionary ? "Non-Discretionary Expenses" : "Discretionary Expenses")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showingCategoryManagement = true
                }) {
                    Image(systemName: "gearshape")
                }
                .sheet(isPresented: $showingCategoryManagement) {
                    CategoryManagementView()
                        .environmentObject(budgetData)
                }
            }
            .padding()

            List {
                ForEach(currentExpenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.body)
                            if let category = budgetData.categories.first(where: { $0.id == expense.categoryID }) {
                                Text(category.name)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: category.colorHex) ?? .gray)
                            }
                        }
                        Spacer()
                        Text(String(format: "$%.2f", expense.amount))
                            .font(.body)
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .listStyle(PlainListStyle())

            // Input fields for new expense
            VStack(spacing: 10) {
                TextField("Expense Name", text: $expenseName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                TextField("Amount", text: $expenseAmountString)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                // Category Picker
                Picker("Category", selection: $selectedCategoryID) {
                    ForEach(filteredCategories) { category in
                        HStack {
                            Circle()
                                .fill(Color(hex: category.colorHex) ?? .gray)
                                .frame(width: 10, height: 10)
                            Text(category.name)
                        }
                        .tag(category.id as UUID?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

                Button(action: addExpense) {
                    Text("Add Expense")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidExpense() ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isValidExpense())
            }
            .padding([.horizontal, .bottom])

            // NavigationLink to proceed to the next step
            NavigationLink(destination: nextDestinationView()) {
                Text(doneButtonTitle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canProceed() ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!canProceed())
            .padding([.horizontal, .bottom])
        }
        .navigationTitle(expenseType == .nonDiscretionary ? "Non-Discretionary Expenses" : "Discretionary Expenses")
        .onAppear {
            // Set default category based on expense type
            if selectedCategoryID == nil {
                if expenseType == .nonDiscretionary {
                    selectedCategoryID = budgetData.categories.first(where: { $0.name.lowercased() == "non-discretionary" })?.id
                } else {
                    selectedCategoryID = budgetData.categories.first(where: { $0.name.lowercased() == "discretionary" })?.id
                }
            }
        }
    }

    var filteredCategories: [Category] {
        // Optionally filter categories based on expense type
        // For more flexibility, you can allow selecting any category
        // Here, we assume that expenseType corresponds to initial default categories
        if expenseType == .nonDiscretionary {
            return budgetData.categories.filter { $0.name.lowercased() == "non-discretionary" }
        } else {
            return budgetData.categories.filter { $0.name.lowercased() == "discretionary" }
        }
    }

    var currentExpenses: [Expense] {
        switch expenseType {
        case .nonDiscretionary:
            return budgetData.expenses.filter { category(of: $0).lowercased() == "non-discretionary" }
        case .discretionary:
            return budgetData.expenses.filter { category(of: $0).lowercased() == "discretionary" }
        }
    }

    func category(of expense: Expense) -> String {
        return budgetData.categories.first(where: { $0.id == expense.categoryID })?.name ?? "Unknown"
    }

    func addExpense() {
        guard let amount = Double(expenseAmountString), !expenseName.trimmingCharacters(in: .whitespaces).isEmpty, let categoryID = selectedCategoryID else {
            return
        }

        let newExpense = Expense(name: expenseName.trimmingCharacters(in: .whitespaces), amount: amount, categoryID: categoryID)
        budgetData.addExpense(newExpense)

        // Reset input fields
        expenseName = ""
        expenseAmountString = ""
    }

    func deleteExpense(at offsets: IndexSet) {
        let expensesToDelete = offsets.map { currentExpenses[$0] }
        for expense in expensesToDelete {
            if let index = budgetData.expenses.firstIndex(where: { $0.id == expense.id }) {
                budgetData.expenses.remove(at: index)
            }
        }
        budgetData.saveData()
    }

    func isValidExpense() -> Bool {
        if let amount = Double(expenseAmountString), amount > 0, !expenseName.trimmingCharacters(in: .whitespaces).isEmpty, selectedCategoryID != nil {
            return true
        }
        return false
    }

    func canProceed() -> Bool {
        // Ensure there's at least one expense in the current category and gross income is greater than zero
        return budgetData.grossIncome > 0 && !currentExpenses.isEmpty
    }

    func doneButtonTitle() -> String {
        expenseType == .nonDiscretionary ? "Done Non-Discretionary" : "Done Discretionary"
    }

    func nextDestinationView() -> some View {
        if expenseType == .nonDiscretionary {
            return AnyView(ExpenseInputView(expenseType: .discretionary))
        } else {
            return AnyView(SummaryView())
        }
    }

}

struct ExpenseInputView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseInputView(expenseType: .nonDiscretionary)
            .environmentObject(BudgetData())
    }
}
