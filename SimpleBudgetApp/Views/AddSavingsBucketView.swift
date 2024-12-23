import SwiftUI

struct AddSavingsBucketView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var goalAmountString: String = ""
    @State private var currentBalanceString: String = ""
    @State private var depositPerPayPeriodString: String = ""
    let remainingAmount: Double
    let onSave: (SavingsBucket) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bucket Details")) {
                    TextField("Name", text: $name)
                    TextField("Goal Amount", text: $goalAmountString)
                        .keyboardType(.decimalPad)
                    TextField("Current Balance", text: $currentBalanceString)
                        .keyboardType(.decimalPad)
                    TextField("Deposit per Pay Period", text: $depositPerPayPeriodString)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Text("Remaining Amount: \(String(format: "$%.2f", remainingAmount))")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Add Savings Bucket")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBucket()
                    }
                    .disabled(!isValidInput())
                }
            }
        }
    }

    func isValidInput() -> Bool {
        guard !name.isEmpty,
              let goalAmount = Double(goalAmountString),
              goalAmount > 0,
              let currentBalance = Double(currentBalanceString),
              currentBalance >= 0,
              currentBalance <= goalAmount,
              let depositPerPayPeriod = Double(depositPerPayPeriodString),
              depositPerPayPeriod > 0 else {
            return false
        }
        return true
    }

    func saveBucket() {
        guard let goalAmount = Double(goalAmountString),
              let currentBalance = Double(currentBalanceString),
              let depositPerPayPeriod = Double(depositPerPayPeriodString) else {
            return
        }

        let newBucket = SavingsBucket(
            id: UUID(),
            name: name,
            goalAmount: goalAmount,
            currentBalance: currentBalance,
            depositPerPayPeriod: depositPerPayPeriod
        )
        onSave(newBucket)
        dismiss()
    }
}
