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
    
    // persistently stored info
    @AppStorage("name") private var name: String = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // viewmodel for coredata logic
    @StateObject private var incomeViewModel: IncomeViewModel
    
    @State private var income: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _incomeViewModel = StateObject(wrappedValue: IncomeViewModel(context: context))
    }

    var body: some View {
        ZStack {
            Background()
            
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
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    func saveUserData() {
        guard !name.isEmpty else {
            alertMessage = "Please enter your name"
            showAlert = true
            return
        }
        
        guard let incomeAmount = Double(income), incomeAmount > 0 else {
            alertMessage = "Please enter a valid monthly income"
            showAlert = true
            return
        }
        
        // Save user preferences
        hasCompletedOnboarding = true
        
        // Create Income entity using the model
        incomeViewModel.setIncome(name: "Monthly Salary", amount: incomeAmount, date: Date(), isRecurring: true)
    }
}

#Preview {
    WelcomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

