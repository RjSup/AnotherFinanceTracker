// Income+Mapping.swift
import Foundation
import CoreData

extension Income {
    convenience init(from model: IncomeModel, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = model.id
        self.name = model.name
        self.amount = model.amount
        self.date = model.date
        self.isRecurring = model.isRecurring
    }
}

extension IncomeModel {
    init(from entity: Income) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
        self.amount = entity.amount
        self.date = entity.date ?? Date()
        self.isRecurring = entity.isRecurring
    }
}
