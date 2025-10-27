//
//  IncomeViewModel.swift
//  FinanceTracker
//
//  Created by Ryan on 27/10/2025.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class IncomeViewModel: ObservableObject  {
    @Published var income: IncomeModel?
    @Published var errorMessage: String?
    
    // the context of coredata
    private var viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    // init view model and make the context the incomes
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchIncome()
    }
    
    // fetch the incomes from coredata
    func fetchIncome() {
        // request all info in Income
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        // request Income.date data
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Income.date, ascending: false)]
        request.fetchLimit = 1

        do {
            // fetch the data (this can throw)
            let results = try viewContext.fetch(request)
            if let result = results.first {
                // map to IncomeModel
                income = IncomeModel(
                    id: result.id ?? UUID(),
                    name: result.name ?? "",
                    amount: result.amount,
                    date: result.date ?? Date(),
                    isRecurring: result.isRecurring
                )
            } else {
                income = nil
            }
        } catch {
            errorMessage = "Failed to fetch income: \(error.localizedDescription)"
        }
    }
    
    // add a new income using current context of data
    func setIncome(name: String, amount: Double, date: Date, isRecurring: Bool) {
        // if an income exists then delete it
        deleteIncome()
        
        // create a new income with the context of income data
        let newIncome = Income(context: viewContext)
        newIncome.id = UUID()
        newIncome.name = name
        newIncome.amount = amount
        newIncome.date = date
        newIncome.isRecurring = isRecurring
        
        // save current context of income data
        saveContext()
            
        // refresh the latest income after saving
        fetchIncome()
    }
    
    func deleteIncome() {
        // request income data
        let request: NSFetchRequest<NSFetchRequestResult> = Income.fetchRequest()
        // request to delete the data in the request
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            // delete the requested info
            try viewContext.execute(deleteRequest)
            // save the data
            try viewContext.save()
            income = nil
        } catch {
            errorMessage = "Failed to delete income: \(error.localizedDescription)"
        }
    }
    
    // view income data
    func showIncome() -> Double {
        return income?.amount ?? 0.0
    }
    
    private func saveContext() {
        do {
            // same the current context of the viewContext data
            try viewContext.save()
        } catch {
            errorMessage = "Unable to save context: \(error.localizedDescription)"
        }
    }
}

