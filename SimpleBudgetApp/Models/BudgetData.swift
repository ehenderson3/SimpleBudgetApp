// BudgetData.swift

import Foundation
import SwiftUI

class BudgetData: ObservableObject {
    // Published properties to allow views to react to changes
    @Published var grossIncome: Double = 0.0
    @Published var categories: [Category] = []
    @Published var expenses: [Expense] = []

    // Emergency Fund Properties
    @Published var emergencyFundGoal: Double = 1000.0 {
        didSet {
            UserDefaults.standard.set(emergencyFundGoal, forKey: "EmergencyFundGoal")
        }
    }
    @Published var emergencyFundBalance: Double = 0.0 {
        didSet {
            UserDefaults.standard.set(emergencyFundBalance, forKey: "EmergencyFundBalance")
        }
    }
    
    init() {
        // Load Emergency Fund Data
        self.emergencyFundGoal = UserDefaults.standard.double(forKey: "EmergencyFundGoal")
        self.emergencyFundBalance = UserDefaults.standard.double(forKey: "EmergencyFundBalance")
        
        // Load other data as needed
        loadData()
    }
    
    
    
    // Computed properties for totals and remaining income
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var remainingIncome: Double {
        grossIncome - totalExpenses
    }



    // MARK: - Data Persistence Methods

    /// Saves the current state of gross income, categories, and expenses to UserDefaults
    func saveData() {
        let encoder = JSONEncoder()
        do {
            // Encode grossIncome
            let encodedIncome = try encoder.encode(grossIncome)
            UserDefaults.standard.set(encodedIncome, forKey: "grossIncome")

            // Encode categories
            let encodedCategories = try encoder.encode(categories)
            UserDefaults.standard.set(encodedCategories, forKey: "categories")

            // Encode expenses
            let encodedExpenses = try encoder.encode(expenses)
            UserDefaults.standard.set(encodedExpenses, forKey: "expenses")
        } catch {
            print("Failed to encode data: \(error.localizedDescription)")
        }
    }

    /// Loads the saved state of gross income, categories, and expenses from UserDefaults
    func loadData() {
        let decoder = JSONDecoder()
        do {
            // Decode grossIncome
            if let savedIncomeData = UserDefaults.standard.data(forKey: "grossIncome") {
                grossIncome = try decoder.decode(Double.self, from: savedIncomeData)
            }

            // Decode categories
            if let savedCategoriesData = UserDefaults.standard.data(forKey: "categories") {
                categories = try decoder.decode([Category].self, from: savedCategoriesData)
            } else {
                // If no categories are saved, initialize with default categories
                categories = [
                    Category(name: "Non-Discretionary", color: .blue),
                    Category(name: "Discretionary", color: .orange)
                ]
                saveData()
            }

            // Decode expenses
            if let savedExpensesData = UserDefaults.standard.data(forKey: "expenses") {
                expenses = try decoder.decode([Expense].self, from: savedExpensesData)
            }
        } catch {
            print("Failed to decode data: \(error.localizedDescription)")
        }
    }

    // MARK: - Methods to Modify Data

    /// Sets the gross income and saves the data
    /// - Parameter income: The gross monthly income entered by the user
    func setGrossIncome(_ income: Double) {
        grossIncome = income
        saveData()
    }

    /// Adds a new category and saves the data
    /// - Parameter category: The category to be added
    func addCategory(_ category: Category) {
        categories.append(category)
        saveData()
    }

    /// Deletes a category and all associated expenses, then saves the data
    /// - Parameter category: The category to be deleted
    func deleteCategory(_ category: Category) {
        // Remove expenses associated with this category
        expenses.removeAll { $0.categoryID == category.id }

        // Remove the category
        categories.removeAll { $0.id == category.id }

        saveData()
    }

    /// Adds an expense and saves the data
    /// - Parameter expense: The expense to be added
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveData()
    }

    /// Removes expenses at specified offsets and saves the data
    /// - Parameter offsets: The index set of expenses to remove
    func removeExpenses(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        saveData()
    }
}
