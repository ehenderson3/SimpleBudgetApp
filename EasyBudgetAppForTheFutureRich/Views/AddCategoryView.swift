// AddCategoryView.swift

import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject var budgetData: BudgetData
    @Environment(\.presentationMode) var presentationMode

    @State private var categoryName: String = ""
    @State private var selectedColor: Color = .blue
    @State private var showAlert = false
    @State private var duplicateName = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Name")) {
                    TextField("Enter category name", text: $categoryName)
                }

                Section(header: Text("Category Color")) {
                    ColorPicker("Select Color", selection: $selectedColor)
                        .labelsHidden()
                }
            }
            .navigationTitle("Add Category")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Add") {
                addCategory()
            }
            .disabled(categoryName.trimmingCharacters(in: .whitespaces).isEmpty))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Name"),
                    message: Text(duplicateName ? "A category with this name already exists." : "Please enter a valid category name."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func addCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            showAlert = true
            duplicateName = false
            return
        }

        // Check for duplicate category names
        if budgetData.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            showAlert = true
            duplicateName = true
            return
        }

        let newCategory = Category(name: trimmedName, color: selectedColor)
        budgetData.addCategory(newCategory)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
            .environmentObject(BudgetData())
    }
}
