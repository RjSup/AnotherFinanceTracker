// ExpenseCategory.swift
// FinanceTracker

import Foundation

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case food, rent, entertainment, transport, utilities, other
    var id: String { rawValue }
}

