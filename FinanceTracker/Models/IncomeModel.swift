// IncomeModel.swift
// FinanceTracker

import Foundation

struct IncomeModel: Identifiable {
    let id: UUID
    let name: String
    let amount: Double
    let date: Date
    let isRecurring: Bool
}

