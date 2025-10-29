//
//  HistoryView.swift
//  FinanceTracker
//
//  Created by Ryan on 27/10/2025.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var expenseViewModel: ExpenseViewModel
    
    @State private var selectedCategory: ExpenseCategory? = nil
    @State private var selectedMonth: Date = Date()
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _expenseViewModel = StateObject(wrappedValue: ExpenseViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month Selector
                HStack {
                    Button(action: {
                        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text(selectedMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding()
                
                // Get filtered expenses from ViewModel
                let filteredExpenses = expenseViewModel.getFilteredExpenses(for: selectedMonth, category: selectedCategory)
                
                // Group by date in the view
                let groupedExpenses = Dictionary(grouping: filteredExpenses) { expense in
                    Calendar.current.startOfDay(for: expense.date)
                }
                let sortedDates = groupedExpenses.keys.sorted(by: >)
                
                // Expenses List
                if sortedDates.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No expenses found")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(sortedDates, id: \.self) { date in
                            Section(header: Text(date.formatted(.dateTime.day().month().year()))) {
                                ForEach(groupedExpenses[date] ?? []) { expense in
                                    ExpenseRowSimple(expense: expense)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("History")
            .toolbar {
                Menu {
                    Button(action: {
                        selectedCategory = nil
                    }) {
                        HStack {
                            Text("All")
                            if selectedCategory == nil {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Divider()
                    
                    ForEach(ExpenseCategory.allCases) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            HStack {
                                Text(category.rawValue.capitalized)
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text(selectedCategory?.rawValue.capitalized ?? "All")
                    }
                }
            }
        }
        .onAppear {
            expenseViewModel.fetchExpenses()
        }
    }
}

// MARK: - Simple Expense Row
struct ExpenseRowSimple: View {
    let expense: ExpenseModel
    
    var body: some View {
        HStack {
            // Expense Details
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                
                Text(expense.category.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            Text("£\(expense.amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    HistoryView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

