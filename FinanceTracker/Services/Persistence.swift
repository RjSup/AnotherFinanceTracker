//
//  Persistence.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample expenses
        for i in 0..<5 {
            let expense = Expense(context: viewContext)
            expense.id = UUID()
            expense.title = "Sample Expense \(i + 1)"
            expense.amount = Double.random(in: 10...200)
            expense.date = Date().addingTimeInterval(-Double(i) * 86400)
            expense.category = ExpenseCategory.allCases.randomElement()?.rawValue ?? "other"
        }
        
        // Create sample incomes
        for i in 0..<3 {
            let income = Income(context: viewContext)
            income.id = UUID()
            income.name = "Sample Income \(i + 1)"
            income.amount = Double.random(in: 1000...5000)
            income.date = Date().addingTimeInterval(-Double(i) * 86400)
            income.isRecurring = i % 2 == 0
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FinanceTracker")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

