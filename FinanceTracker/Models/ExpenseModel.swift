// ExpenseModel.swift
// FinanceTracker

import Foundation

struct ExpenseModel: Identifiable {
    let id: UUID
    let title: String
    let amount: Double
    let category: ExpenseCategory
    let date: Date
}

