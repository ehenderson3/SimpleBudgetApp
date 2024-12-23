import Foundation

struct SavingsBucket: Identifiable {
    let id: UUID
    var name: String
    var goalAmount: Double
    var currentBalance: Double
    var depositPerPayPeriod: Double

    var payPeriodsRemaining: Int {
        guard depositPerPayPeriod > 0 else { return 0 } // Avoid division by zero
        return Int(ceil((goalAmount - currentBalance) / depositPerPayPeriod))
    }
}
