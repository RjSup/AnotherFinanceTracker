//
//  MainDashboardView.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//

import SwiftUI
import CoreData

struct MainDashboardView: View {
    // context of the coredata obbjects
    @Environment(\.managedObjectContext) private var viewContext
    // contect of the userdefaults data
    @AppStorage("name") private var name: String = ""
    
    // query to fetch data from coredata
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Income.date, ascending: false)],
        animation: .default)
    private var incomes: FetchedResults<Income>
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Welcome back, \(name)")
                    .font(.headline)
                
                if let userIncome = incomes.first {
                    VStack(spacing: 10) {
                        Text("Your income")
                        
                        Text("£\(userIncome.amount, specifier: "%.2f")")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.green)
                    }
                } else {
                    Text("No income data")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

#Preview {
    MainDashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
