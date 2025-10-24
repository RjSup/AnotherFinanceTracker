// Expense+Mapping.swift
// FinanceTracker

import Foundation
import CoreData

// Struct -> Core Data
extension Expense {
    convenience init(from model: ExpenseModel, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = model.id
        self.title = model.title
        self.amount = model.amount
        self.date = model.date
        self.category = model.category.rawValue
    }
}

// Core Data -> Struct
extension ExpenseModel {
    init(from entity: Expense) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? ""
        self.amount = entity.amount
        self.date = entity.date ?? Date()
        self.category = ExpenseCategory(rawValue: entity.category ?? "") ?? .other
    }
}

