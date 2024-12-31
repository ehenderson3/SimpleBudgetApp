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
                if buckets.isEmpty {
                    Text("No savings buckets yet. Add one!")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(buckets) { bucket in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(bucket.name)
                                    .font(.headline)
                                Text(String(format: "Goal: $%.2f", bucket.goalAmount))
                                    .font(.subheadline)
                                Text(String(format: "Balance: $%.2f", bucket.currentBalance))
                                    .font(.subheadline)
                                Text(String(format: "Deposit per Pay Period: $%.2f", bucket.depositPerPayPeriod))
                                    .font(.subheadline)
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
                            .disabled(bucket.depositPerPayPeriod > remainingAmount)
                        }
                    }
                    .onDelete(perform: deleteBucket)
                }
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
                    budgetData.savingsBuckets = buckets // Sync with BudgetData
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            loadBuckets()
            calculateRemainingAmount()
        }
    }

    func loadBuckets() {
        // Load buckets from BudgetData
        buckets = budgetData.savingsBuckets
    }

    func calculateRemainingAmount() {
        remainingAmount = budgetData.remainingIncome - totalDepositPerPayPeriod
    }

    func deleteBucket(at offsets: IndexSet) {
        for offset in offsets {
            let bucketToRemove = buckets[offset]
            buckets.remove(at: offset)

            // Sync with BudgetData
            budgetData.savingsBuckets.removeAll { $0.id == bucketToRemove.id }
        }
        calculateRemainingAmount()
    }

    func addPayPeriodDeposit(to bucket: SavingsBucket) {
        guard let index = buckets.firstIndex(where: { $0.id == bucket.id }) else { return }
        let deposit = buckets[index].depositPerPayPeriod

        // Ensure deposit doesn't exceed remainingAmount
        if deposit > remainingAmount {
            // Optionally, show an alert here if desired
            return
        }

        buckets[index].currentBalance += deposit
        remainingAmount -= deposit // Deduct from remaining amount
        budgetData.updateSavingsBucket(buckets[index])
    }
}

 
