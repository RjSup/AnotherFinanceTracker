//
//  WelcomeView.swift
//  FinanceTracker
//
//  Created by Ryan on 24/10/2025.
//

import SwiftUI
internal import CoreData

struct WelcomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.income, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var name: String = ""
    @State private var income: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("insert Finance App name here")
                .font(.title)
                .bold()
            
            TextField("Enter name:", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Enter income:", text: $income)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Get started") {
                saveUserData()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    func saveUserData() {
        // convert income from text to double and store in Core Date entity
        // save name and onboarding complete
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        withAnimation {
            let newIncome = Item(context: viewContext)
            newIncome.income = Double(income) ?? 0

            do {
                try viewContext.save()
                print(newIncome)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    WelcomeView()
}
