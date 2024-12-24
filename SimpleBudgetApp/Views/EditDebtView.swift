import SwiftUI


struct EditDebtView: View {
    @Environment(\.dismiss) var dismiss
    @State var debt: Debt
    var onSave: (Debt) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Debt").font(.largeTitle).padding()
            TextField("Debt Name", text: $debt.name)
            TextField("Balance", value: $debt.balance, format: .number).keyboardType(.decimalPad)
            TextField("Interest Rate (%)", value: $debt.interestRate, format: .number).keyboardType(.decimalPad)
            TextField("Minimum Payment", value: $debt.minimumPayment, format: .number).keyboardType(.decimalPad)

            Button("Save") {
                onSave(debt)
                dismiss()
            }
        }
        .padding()
    }
}
