import SwiftUI

struct SavingsBucketView: View {
    @EnvironmentObject var budgetData: BudgetData
    @State private var buckets: [SavingsBucket] = []
    @State private var remainingAmount: Double = 0.0
    @State private var showingAddBucketModal: Bool = false

    var totalDepositPerPayPeriod: Double {
        buckets.reduce(0) { $0 + $1.depositPerPayPeriod }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Savings Buckets")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text(String(format: "Remaining Amount: $%.2f", remainingAmount))
                .font(.headline)
                .foregroundColor(remainingAmount >= 0 ? .green : .red)

            Text(String(format: "Total Deposit per Pay Period: $%.2f", totalDepositPerPayPeriod))
                .font(.subheadline)
                .padding(.bottom)

            List {
                ForEach(buckets) { bucket in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(bucket.name)
                                .font(.headline)
                            Text(String(format: "Goal: $%.2f", bucket.goalAmount))
                            Text(String(format: "Balance: $%.2f", bucket.currentBalance))
                            Text(String(format: "Deposit per Pay Period: $%.2f", bucket.depositPerPayPeriod))
                            Text("Pay Periods Remaining: \(bucket.payPeriodsRemaining)")
                        }
                        Spacer()
                        Button(action: { addPayPeriodDeposit(to: bucket) }) {
                            Text("Add Deposit")
                                .font(.subheadline)
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .onDelete(perform: deleteBucket)
            }

            Button(action: {
                showingAddBucketModal = true
            }) {
                Text("Add Savings Bucket")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(remainingAmount > 0 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(remainingAmount <= 0)
            .padding(.horizontal)
            .sheet(isPresented: $showingAddBucketModal) {
                AddSavingsBucketView(remainingAmount: remainingAmount) { newBucket in
                    buckets.append(newBucket)
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            calculateRemainingAmount()
        }
    }

    func calculateRemainingAmount() {
        remainingAmount = budgetData.remainingIncome - totalDepositPerPayPeriod
    }

    func deleteBucket(at offsets: IndexSet) {
        for offset in offsets {
            buckets.remove(at: offset)
        }
        calculateRemainingAmount()
    }

    func addPayPeriodDeposit(to bucket: SavingsBucket) {
        guard let index = buckets.firstIndex(where: { $0.id == bucket.id }) else { return }
        let deposit = buckets[index].depositPerPayPeriod
        buckets[index].currentBalance += deposit
        calculateRemainingAmount()
    }
}
