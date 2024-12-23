import SwiftUI

struct AddDebtView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var balance: String = ""
    @State private var interestRate: String = ""
    @State private var minimumPayment: String = ""
    let onSave: (Debt) -> Void // Callback to save the new debt

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Debt Details")) {
                    TextField("Name", text: $name)
                    TextField("Balance", text: $balance)
                        .keyboardType(.decimalPad)
                    TextField("Interest Rate (%)", text: $interestRate)
                        .keyboardType(.decimalPad)
                    TextField("Minimum Payment", text: $minimumPayment)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Debt")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDebt()
                    }
                    .disabled(!isValidInput())
                }
            }
        }
    }

    func isValidInput() -> Bool {
        guard !name.isEmpty,
              let _ = Double(balance),
              let _ = Double(interestRate),
              let _ = Double(minimumPayment) else {
            return false
        }
        return true
    }

    func saveDebt() {
        guard let balanceValue = Double(balance),
              let interestRateValue = Double(interestRate),
              let minimumPaymentValue = Double(minimumPayment) else {
            return
        }

        let newDebt = Debt(
            id: UUID(),
            name: name,
            balance: balanceValue,
            interestRate: interestRateValue,
            minimumPayment: minimumPaymentValue
        )
        onSave(newDebt)
        dismiss()
    }
}
