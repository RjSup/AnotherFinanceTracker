//
//  ExpensesView.swift
//  FinanceTracker
//
//  Created by Ryan on 27/10/2025.
//

import SwiftUI
import CoreData

struct ExpensesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var expenseViewModel: ExpenseViewModel

    @State private var sheetShowing: Bool = false
    
    // init viewmodel contexts
    init() {
        let context = PersistenceController.shared.container.viewContext
        _expenseViewModel = StateObject(wrappedValue: ExpenseViewModel(context: context))
    }
    
    var body: some View {
        ZStack {
            Background()
                .ignoresSafeArea()
            
            NavigationStack {
                // no expenses
                VStack {
                    if expenseViewModel.expenses.isEmpty {
                        VStack(spacing: 16) {
                            Text("No Expenes")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else {
                        // expenses exist
                        List {
                            ForEach(expenseViewModel.expenses) { expense in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(expense.title)
                                            .font(.headline)
                                        
                                        Text(expense.category.rawValue.capitalized)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("£\(expense.amount, specifier: "%.2f")")
                                            .bold()
                                        
                                        Text(expense.date, style: .date)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteExpense)
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .navigationTitle("Expenses")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add expense", systemImage: "plus") {
                            sheetShowing.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $sheetShowing) {
                    AddExpenseView(expenseViewModel: expenseViewModel)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(450)])
                        // .presentationBackground(.blue.opacity(0.9))
                }
            }
        }
    }
    
    private func deleteExpense(at offset: IndexSet) {
        for index in offset {
            let expense = expenseViewModel.expenses[index]
            expenseViewModel.deleteExpense(id: expense.id)
        }
    }
}

#Preview {
    ExpensesView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
