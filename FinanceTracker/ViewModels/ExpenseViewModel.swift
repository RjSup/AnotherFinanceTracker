//
//  ExpenseViewModel.swift
//  FinanceTracker
//
//  Created by Ryan on 27/10/2025.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [ExpenseModel] = []
    @Published var errorMessage: String?
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExpenses()
    }
    
    func addExpense(title: String, amount: Double, category: ExpenseCategory, date: Date) {
        let newExpense = Expense(context: viewContext)
        newExpense.id = UUID()
        newExpense.title = title
        newExpense.amount = amount
        newExpense.category = category.rawValue
        newExpense.date = date
        
        saveContext()
        fetchExpenses()
    }
    
    func fetchExpenses() {
        // request all info in Income
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        // request Income.date data
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]

        do {
            // fetch the data (this can throw)
            let results = try viewContext.fetch(request)
            self.expenses = results.map { expense in
                // map to ExpenseModel
                ExpenseModel(
                    id: expense.id ?? UUID(),
                    title: expense.title ?? "",
                    amount: expense.amount,
                    category: ExpenseCategory(rawValue: expense.category ?? "Other") ?? .other,
                    date: expense.date ?? Date()
                )
            }
        } catch {
            errorMessage = "Failed to fetch expenses: \(error.localizedDescription)"
        }
    }
    
    func updateExpense(id: UUID, title: String, amount: Double, category: ExpenseCategory, date: Date) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == $@", id as CVarArg)
        
        do {
            if let expense = try viewContext.fetch(request).first {
                expense.title = title
                expense.amount = amount
                expense.category = category.rawValue
                expense.date = date
                saveContext()
                fetchExpenses()
            }
        } catch {
            errorMessage = "Failed to modify request: \(error.localizedDescription)"
        }
    }
    
    func deleteExpense(id: UUID) {
        // request income data
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            // if context can find an expense (first one)
            if let expense = try viewContext.fetch(request).first {
                // delete it
                viewContext.delete(expense)
                // save state of core data
                saveContext()
                // fetch updated expenses
                fetchExpenses()
            }
        } catch {
            errorMessage = "Failed to delete expense: \(error.localizedDescription)"
        }
    }
    
    func getTotalExpenses(for month: Date? = nil, category: ExpenseCategory? = nil) -> Double {
        // get all expenses to filter
        var filtered = expenses
        
        // if filtering by month
        if let month = month {
            // get current date
            let calender = Calendar.current
            // filter by calander days
            filtered = filtered.filter { calender.isDate($0.date, equalTo: month, toGranularity: .month) }
        }
        
        // if filtered by category
        if let category = category {
            // if category exists then filter by it
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered.reduce(0) { $0 + $1.amount }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to save context: \(error.localizedDescription)"
        }
    }
}
