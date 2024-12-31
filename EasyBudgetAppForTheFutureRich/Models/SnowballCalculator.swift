import Foundation

class SnowballCalculator {
    func calculate(debts: [Debt], extraPayment: Double) -> [DebtPlan] {
        var remainingDebts = debts.sorted(by: { $0.balance < $1.balance }) // Smallest debt first
        var plans: [DebtPlan] = []
        var extra = extraPayment
        
        while !remainingDebts.isEmpty {
            let currentDebt = remainingDebts.removeFirst()
            var currentBalance = currentDebt.balance
            var totalPayments = 0.0
            var months = 0

            while currentBalance > 0 {
                let payment = min(currentDebt.minimumPayment + extra, currentBalance)
                currentBalance -= payment
                totalPayments += payment
                months += 1
            }

            extra += currentDebt.minimumPayment // Roll over the minimum payment to the extra fund
            plans.append(DebtPlan(debt: currentDebt, totalPaid: totalPayments, monthsToPayOff: months))
        }
        
        return plans
    }
}

struct DebtPlan {
    let debt: Debt
    let totalPaid: Double
    let monthsToPayOff: Int
}
