//
//  WelcomeView.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//
import SwiftUI
import CoreData

struct WelcomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Income.date, ascending: false)],
        animation: .default)
    private var incomes: FetchedResults<Income>
    
    @State private var name: String = ""
    @State private var income: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Finance Tracker")
                .font(.largeTitle)
                .bold()
            
            Text("Welcome! Let's get started")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter your name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.top)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Monthly Income")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter your monthly income", text: $income)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            
            Button("Get Started") {
                saveUserData()
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.isEmpty || income.isEmpty)
            .padding(.top)
        }
        .padding()
    }
    
    func saveUserData() {
        guard let incomeAmount = Double(income), incomeAmount > 0 else {
            return
        }
        
        // Save user preferences
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Create Income entity using the model
        let incomeModel = IncomeModel(
            id: UUID(),
            name: "Monthly Salary",
            amount: incomeAmount,
            date: Date(),
            isRecurring: true
        )
        
        withAnimation {
            // Convert to CoreData entity and save
            let newIncome = Income(from: incomeModel, context: viewContext)
            
            do {
                try viewContext.save()
                print("Saved income: \(newIncome.name ?? "") - $\(newIncome.amount)")
            } catch {
                let nsError = error as NSError
                print("Error saving income: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
