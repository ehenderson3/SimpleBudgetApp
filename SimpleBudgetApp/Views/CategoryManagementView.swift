// CategoryManagementView.swift

import SwiftUI

struct CategoryManagementView: View {
    @EnvironmentObject var budgetData: BudgetData
    @State private var showingAddCategory = false
    @State private var showingEditCategory = false
    @State private var categoryToEdit: Category?
    @State private var showingDeleteConfirmation = false
    @State private var categoryToDelete: Category?

    var body: some View {
        NavigationView {
            List {
                ForEach(budgetData.categories) { category in
                    HStack {
                        // Display category color
                        Circle()
                            .fill(Color(hex: category.colorHex) ?? Color.gray)
                            .frame(width: 20, height: 20)

                        Text(category.name)
                            .font(.body)
                        
                        Spacer()
                        
                        // Edit button
                        Button(action: {
                            categoryToEdit = category
                            showingEditCategory = true
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete(perform: initiateDeleteCategory)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Manage Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCategory = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView()
                    .environmentObject(budgetData)
            }
            .sheet(item: $categoryToEdit) { category in
                EditCategoryView(category: category)
                    .environmentObject(budgetData)
            }
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete Category"),
                    message: Text("Deleting this category will also remove all associated expenses. Are you sure you want to proceed?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let category = categoryToDelete {
                            budgetData.deleteCategory(category)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    func initiateDeleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let category = budgetData.categories[index]
            // Prevent deletion of default categories
            if category.name.lowercased() == "non-discretionary" || category.name.lowercased() == "discretionary" {
                continue // Skip deletion
            }
            categoryToDelete = category
            showingDeleteConfirmation = true
        }
    }
}

struct CategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryManagementView()
            .environmentObject(BudgetData())
    }
}
