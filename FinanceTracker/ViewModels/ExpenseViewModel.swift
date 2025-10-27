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
        // fetchExpenses()
    }
    
    func addExpenses(title: String, amount: Double, category: ExpenseCategory, date: Date) {
        let newExpense = Expense(context: viewContext)
        newExpense.id = UUID()
        newExpense.title = title
        newExpense.amount = amount
        newExpense.category = category.rawValue
        newExpense.date = date
        
        saveContext()
        // fetchExpenses()
    }
    
    func fechExpenses() {
        // request all info in Income
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        // request Income.date data
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
        request.fetchLimit = 1

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
    
    func updateExpense() {
        
    }
    
    func deleteExpense() {
        
    }
    
    func getTotalExpenses() {
        
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to save context: \(error.localizedDescription)"
        }
    }
}
