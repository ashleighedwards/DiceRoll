//
//  SettingsView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferences")) {
                    Toggle("Enable notifications", isOn: $notificationsEnabled)
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
                
                Section {
                    Button(role: .destructive) {
                        print("Logging out")
                    } label: {
                        Text("Log out")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
