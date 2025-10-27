//
//  MainDashboardView.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//

import SwiftUI
import CoreData

struct MainDashboardView: View {
    
    var body: some View {
        VStack {
            TabView {
                HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                ExpensesView()
                .tabItem {
                    Label("Expenses", systemImage: "plus.circle")
                }
                HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview {
    MainDashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
