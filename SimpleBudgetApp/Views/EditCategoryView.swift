// EditCategoryView.swift

import SwiftUI

struct EditCategoryView: View {
    @EnvironmentObject var budgetData: BudgetData
    @Environment(\.presentationMode) var presentationMode

    @State var category: Category
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
            .navigationTitle("Edit Category")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveChanges()
            }
            .disabled(categoryName.trimmingCharacters(in: .whitespaces).isEmpty))
            .onAppear {
                self.categoryName = category.name
                self.selectedColor = Color(hex: category.colorHex) ?? .blue
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Name"),
                    message: Text(duplicateName ? "A category with this name already exists." : "Please enter a valid category name."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func saveChanges() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            showAlert = true
            duplicateName = false
            return
        }

        // Check for duplicate category names excluding the current category
        if budgetData.categories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() && $0.id != category.id }) {
            showAlert = true
            duplicateName = true
            return
        }

        // Update category
        if let index = budgetData.categories.firstIndex(where: { $0.id == category.id }) {
            budgetData.categories[index].name = trimmedName
            budgetData.categories[index].colorHex = selectedColor.toHex()
            budgetData.saveData()
        }

        presentationMode.wrappedValue.dismiss()
    }
}

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(category: Category(name: "Test Category", color: .purple))
            .environmentObject(BudgetData())
    }
}
