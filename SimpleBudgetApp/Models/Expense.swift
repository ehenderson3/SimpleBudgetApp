// Expense.swift

import Foundation

// MARK: - Expense Model
struct Expense: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var amount: Double
    var categoryID: UUID // Reference to the associated Category

    init(id: UUID = UUID(), name: String, amount: Double, categoryID: UUID) {
        self.id = id
        self.name = name
        self.amount = amount
        self.categoryID = categoryID
    }
}
