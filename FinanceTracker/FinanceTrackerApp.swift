//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//

import SwiftUI
internal import CoreData

@main
struct FinanceTrackerApp: App {
    // has the user completed onboarding
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    // enable persistance through coredata
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            // check if the user has completed onboarding
            if hasCompletedOnboarding {
                // if they have go to main view
                MainDashboardView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                // they havent go to onboarding page
                WelcomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
