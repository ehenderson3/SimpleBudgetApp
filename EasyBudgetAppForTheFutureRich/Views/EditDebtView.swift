import SwiftUI

struct EditDebtView: View {
    @Binding var debt: Debt
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var balance: String = ""
    @State private var interestRate: String = ""
    @State private var minimumPayment: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                showEditModal(for: debt)
            }) {
                Text("Edit")
                    .font(.subheadline)
                    .padding(8)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Balance", text: $balance)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Interest Rate", text: $interestRate)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Minimum Payment", text: $minimumPayment)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: saveDebt) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .onAppear {
            // Initialize with current debt values
            name = debt.name
            balance = String(format: "%.2f", debt.balance)
            interestRate = String(format: "%.2f", debt.interestRate)
            minimumPayment = String(format: "%.2f", debt.minimumPayment)
        }
    }

    @State private var debtToEdit: Debt? = nil
    @State private var showingEditDebtModal: Bool = false

    func showEditModal(for debt: Debt) {
        debtToEdit = debt
        showingEditDebtModal = true
    }

    func saveDebt() {
        guard
            let updatedBalance = Double(balance),
            let updatedInterestRate = Double(interestRate),
            let updatedMinimumPayment = Double(minimumPayment)
        else {
            return // Handle invalid input
        }

        debt.name = name
        debt.balance = updatedBalance
        debt.interestRate = updatedInterestRate
        debt.minimumPayment = updatedMinimumPayment

        dismiss()
    }
}

