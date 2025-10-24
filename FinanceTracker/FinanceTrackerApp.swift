//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//

import SwiftUI
import CoreData

@main
struct FinanceTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
