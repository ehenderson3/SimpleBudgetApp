import Foundation

// MARK: - ExpenseType Enum
enum ExpenseType {
    case nonDiscretionary
    case discretionary
}

// MARK: - BudgetDestination Enum
enum BudgetDestination: Hashable {
    case incomeInput
    case expenseInput(ExpenseType)
    case summary
    case report
    case emergencyFund
    case snowball
    case savingsBuckets // New case


}
