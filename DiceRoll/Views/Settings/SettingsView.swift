//
//  SettingsView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Enable Dark Mode", isOn: $isDarkMode)
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileView()) {
                        Text("Profile")
                    }
                    NavigationLink(destination: Text("Change password")) {
                        Text("Change password")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
