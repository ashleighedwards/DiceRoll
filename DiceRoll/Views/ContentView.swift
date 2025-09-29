//
//  ContentView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            HomeView(context: viewContext)
                .tabItem {
                    Label(LanguageManager.shared.localizedString(for: "Home"), systemImage: "house")
                }
            
            GamesView()
                .tabItem {
                    Label(LanguageManager.shared.localizedString(for: "Games"), systemImage: "puzzlepiece")
                }
            
            SettingsView()
                .tabItem {
                    Label(LanguageManager.shared.localizedString(for: "Settings"), systemImage: "gear")
                }
        }
    }
}


#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
