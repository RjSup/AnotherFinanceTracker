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
    // has the user completed onboarding
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    // enable persistance through coredata
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainDashboardView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .transition(.opacity)
                } else {
                    WelcomeView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: hasCompletedOnboarding)
        }
    }

}
