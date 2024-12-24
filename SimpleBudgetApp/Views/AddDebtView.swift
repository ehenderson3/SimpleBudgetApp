import SwiftUI


struct AddDebtView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var balance: String = ""
    @State private var interestRate: String = ""
    @State private var minimumPayment: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false

    var onSave: (Debt) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Debt").font(.largeTitle).padding()
            TextField("Debt Name", text: $name)
            TextField("Balance", text: $balance).keyboardType(.decimalPad)
            TextField("Interest Rate (%)", text: $interestRate).keyboardType(.decimalPad)
            TextField("Minimum Payment", text: $minimumPayment).keyboardType(.decimalPad)

            Button("Save") {
                guard validateInput() else { return }
                let newDebt = Debt(
                    id: UUID(),
                    name: name,
                    balance: Double(balance) ?? 0,
                    interestRate: Double(interestRate) ?? 0,
                    minimumPayment: Double(minimumPayment) ?? 0
                )
                onSave(newDebt) // Pass the new debt back to the parent view
                dismiss()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Invalid Input"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    func validateInput() -> Bool {
        guard !name.isEmpty else {
            alertMessage = "Debt name cannot be empty."
            showingAlert = true
            return false
        }
        guard let balance = Double(balance), balance > 0 else {
            alertMessage = "Please enter a valid balance."
            showingAlert = true
            return false
        }
        guard let interest = Double(interestRate), interest >= 0 else {
            alertMessage = "Please enter a valid interest rate."
            showingAlert = true
            return false
        }
        guard let payment = Double(minimumPayment), payment > 0 else {
            alertMessage = "Please enter a valid minimum payment."
            showingAlert = true
            return false
        }
        return true
    }
}

