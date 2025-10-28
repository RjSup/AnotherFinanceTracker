//
//  AddExpenseView.swift
//  FinanceTracker
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var expenseViewModel: ExpenseViewModel
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category = ExpenseCategory.other
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $category) {
                    ForEach(ExpenseCategory.allCases) { cat in
                        Text(cat.rawValue.capitalized).tag(cat)
                    }
                }

                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(title.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        
        expenseViewModel.addExpense(
            title: title,
            amount: amountValue,
            category: category,
            date: date
        )
        
        dismiss()
    }
}

