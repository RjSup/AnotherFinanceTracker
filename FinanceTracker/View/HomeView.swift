//
//  HomeView.swift
//  FinanceTracker
//
//  Created by Ryan on 27/10/2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    // context of the coredata obbjects
    @Environment(\.managedObjectContext) private var viewContext
    // contect of the userdefaults data
    @AppStorage("name") private var name: String = ""
   // context for the view models
    @StateObject private var incomeViewModel: IncomeViewModel
    @StateObject private var expenseViewModel: ExpenseViewModel
    
    @State private var currentDate: Date = Date()
    
    // init viewmodel contexts
    init() {
        let context = PersistenceController.shared.container.viewContext
        _incomeViewModel = StateObject(wrappedValue: IncomeViewModel(context: context))
        _expenseViewModel = StateObject(wrappedValue: ExpenseViewModel(context: context))
    }
    
    var body: some View {
        ZStack {
            Background()
            ScrollView {
                // header
                VStack {
                    Text("Hi, \(name)")
                        .font(.title)
                    
                    Text("Welcome back!")
                        .font(.headline)
                }

                // Income info
                ZStack() {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(width: 350, height: 200)
                    
                        VStack(spacing: 20) {
                            Text(currentDate.formatted(.dateTime.month(.wide).year()))
                                .font(.title)
                            
                            Text("Your income")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            if let income = incomeViewModel.income {
                                Text("£\(income.amount, specifier: "%.2f")")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.green)
                            } else {
                                Text("No income data")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onAppear {
                            incomeViewModel.fetchIncome()
                        }
                }
                    
                //Expenses
                ZStack() {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(width: 350, height: 200)
                    
                    VStack(spacing: 20) {
                        Text("Recent expenses")
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        // no expenses
                        if expenseViewModel.expenses.isEmpty {
                            Text("No Expenses yet")
                                .foregroundColor(.secondary)
                        } else {
                            // show some expenses
                            ForEach(expenseViewModel.expenses.prefix(5)) { expense in
                                HStack {
                                    Text(expense.title)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("-£\(expense.amount, specifier: "%.2f")")
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        expenseViewModel.fetchExpenses()
                    }
                }
                
                // balance
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(width: 350, height: 200)
                    
                    VStack(spacing: 20) {
                        Text("Balance after expenses")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
