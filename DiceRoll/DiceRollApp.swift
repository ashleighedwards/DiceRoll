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
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var hasLoaded = false
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if hasLoaded {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environmentObject(appState)
                    .onAppear {
                        persistenceController.purgeOldOrders(olderThan: 5)
                    }
            } else {
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            hasLoaded = true
                        }
                    }
            }
        }
        .onChange(of: scenePhase) {_, newPhase in
            if newPhase == .active {
                persistenceController.purgeOldOrders(olderThan: 5)
            }
        }
    }
}
