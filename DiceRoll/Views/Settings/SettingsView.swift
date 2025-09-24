//
//  SettingsView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: LanguageViewModel
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: LanguageViewModel(context: context))
    }
    
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
                }
                
                Section(header: Text("Language & Region")) {
                    HStack {
                        Text("Language")
                        Spacer()
                        Picker("", selection: $viewModel.language) {
                            ForEach(viewModel.availableLanguages) { language in
                                Text(language.name).tag(language.code)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: viewModel.language) {
                            viewModel.saveLanguageAndRegion()
                        }
                    }
                    HStack {
                        Text("Region")
                        Spacer()
                        Picker("", selection: $viewModel.region) {
                            ForEach(viewModel.availableRegions) { region in
                                Text(region.name).tag(region.id)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: viewModel.region) {
                            viewModel.saveLanguageAndRegion()
                        }

                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
