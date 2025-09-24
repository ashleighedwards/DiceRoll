//
//  DiceRollApp.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import SwiftUI
import CoreData

@main
struct DiceRollApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    let persistenceController = PersistenceController.shared
    
    @State private var hasLoaded = false
    
    var body: some Scene {
        WindowGroup {
            if hasLoaded {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            hasLoaded = true
                        }
                    }
            }
            
        }
    }
}
