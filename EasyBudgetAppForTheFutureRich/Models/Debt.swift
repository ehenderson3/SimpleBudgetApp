import Foundation

struct Debt: Identifiable {
    let id: UUID
    var name: String
    var balance: Double
    var interestRate: Double
    var minimumPayment: Double
}
