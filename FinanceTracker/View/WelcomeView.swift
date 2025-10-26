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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.date, ascending: false)],
        animation: .default
    )
    private var incomes: FetchedResults<Income>
    
    @State private var name: String = ""
    @State private var income: String = ""
    
    var body: some View {
        ZStack {
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.5, 1.0], [0.7, 0.5], [1.0, 0.7],
                    [0.0, 1.0], [0.0, 0.5], [0.0, 0.5]
                ],
                colors: [
                    .teal, .purple, .indigo,
                    .purple, .blue, .pink,
                    .purple, .red, .purple
                ]
            )
            .ignoresSafeArea()
            .shadow(color: .gray, radius: 25, x: -10, y: 10)
            
            // Placeholder foreground content so the view compiles and renders
            VStack(spacing: 16) {
                Text("Welcome")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                TextField("Your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                TextField("Monthly income", text: $income)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                Button("Save") {
                    saveUserData()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()
        }
    }
    
    // Moved outside of `body` so the computed property can return a View
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

