// ExpenseInputView.swift

// ExpenseInputView.swift

import SwiftUI

struct ExpenseInputView: View {
    @EnvironmentObject var budgetData: BudgetData
    var expenseType: ExpenseType
    @State private var expenseName: String = ""
    @State private var expenseAmountString: String = ""
    @State private var selectedCategoryID: UUID?
    @State private var showingCategoryManagement = false
    @State private var editingExpense: Expense? // Track the expense being edited
    @State private var showingEditExpenseModal = false

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Remaining Income: \(String(format: "$%.2f", budgetData.remainingIncome))")
                    .font(.subheadline)
                    .foregroundColor(budgetData.remainingIncome >= 0 ? .green : .red)
                Spacer()
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

            // Expense List
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
                        Button(action: {
                            editExpense(expense)
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .listStyle(PlainListStyle())

            // New Expense Input
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

                Picker("Category", selection: $selectedCategoryID) {
                    ForEach(filteredCategories) { category in
                        Text(category.name)
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

            // Navigation Button
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
        .sheet(isPresented: $showingEditExpenseModal) {
            EditExpenseView(expense: $editingExpense)
                .environmentObject(budgetData)
        }
        .onAppear {
            if selectedCategoryID == nil {
                selectedCategoryID = defaultCategoryID
            }
        }
    }

    var defaultCategoryID: UUID? {
        if expenseType == .nonDiscretionary {
            return budgetData.categories.first(where: { $0.name.lowercased() == "non-discretionary" })?.id
        } else {
            return budgetData.categories.first(where: { $0.name.lowercased() == "discretionary" })?.id
        }
    }

    var filteredCategories: [Category] {
        if expenseType == .nonDiscretionary {
            return budgetData.categories.filter { $0.name.lowercased() == "non-discretionary" }
        } else {
            return budgetData.categories.filter { $0.name.lowercased() == "discretionary" }
        }
    }

    var currentExpenses: [Expense] {
        budgetData.expenses.filter { category(of: $0).lowercased() == (expenseType == .nonDiscretionary ? "non-discretionary" : "discretionary") }
    }

    func category(of expense: Expense) -> String {
        budgetData.categories.first(where: { $0.id == expense.categoryID })?.name ?? "Unknown"
    }

    func addExpense() {
        guard let amount = Double(expenseAmountString),
              !expenseName.trimmingCharacters(in: .whitespaces).isEmpty,
              let categoryID = selectedCategoryID else { return }

        let newExpense = Expense(name: expenseName.trimmingCharacters(in: .whitespaces), amount: amount, categoryID: categoryID)
        budgetData.addExpense(newExpense)

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

    func editExpense(_ expense: Expense) {
        editingExpense = expense
        showingEditExpenseModal = true
    }

    func isValidExpense() -> Bool {
        guard let amount = Double(expenseAmountString), amount > 0 else { return false }
        return !expenseName.trimmingCharacters(in: .whitespaces).isEmpty && selectedCategoryID != nil
    }

    func doneButtonTitle() -> String {
        expenseType == .nonDiscretionary ? "Done Non-Discretionary" : "Done Discretionary"
    }

    func canProceed() -> Bool {
        budgetData.grossIncome > 0 && !currentExpenses.isEmpty
    }

    func nextDestinationView() -> some View {
        if expenseType == .nonDiscretionary {
            return AnyView(ExpenseInputView(expenseType: .discretionary).environmentObject(budgetData))
        } else {
            return AnyView(SummaryView().environmentObject(budgetData))
        }
    }
}

// EditExpenseView Implementation
struct EditExpenseView: View {
    @Binding var expense: Expense?
    @EnvironmentObject var budgetData: BudgetData

    var body: some View {
        VStack {
            if let expense = expense {
                TextField("Expense Name", text: Binding(
                    get: { expense.name },
                    set: { budgetData.updateExpense(expenseID: expense.id, name: $0, amount: expense.amount, categoryID: expense.categoryID) }
                ))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Expense Amount", text: Binding(
                    get: { String(expense.amount) },
                    set: { budgetData.updateExpense(expenseID: expense.id, name: expense.name, amount: Double($0) ?? 0, categoryID: expense.categoryID) }
                ))
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
        }
        .padding()
    }
}
