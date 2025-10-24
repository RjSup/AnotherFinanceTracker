//
//  MainDashboardView.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//

import SwiftUI

struct MainDashboardView: View {
    @AppStorage("name") private var name: String = ""
    
    var body: some View {
        Text("Hello, \(name)")
    }
}

#Preview {
    MainDashboardView()
}
