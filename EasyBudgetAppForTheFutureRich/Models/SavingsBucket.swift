import Foundation

struct SavingsBucket: Identifiable, Codable {
    let id: UUID
    var name: String
    var goalAmount: Double
    var currentBalance: Double
    var depositPerPayPeriod: Double

    var payPeriodsRemaining: Int {
        let remaining = max(0, goalAmount - currentBalance) / depositPerPayPeriod
        return Int(ceil(remaining))
    }
}
