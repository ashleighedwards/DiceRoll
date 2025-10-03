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
                Section(header: Text(LanguageManager.shared.localizedString(for: "Preferences"))) {
                    Toggle(LanguageManager.shared.localizedString(for: "Enable Dark Mode"), isOn: $isDarkMode)
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text(LanguageManager.shared.localizedString(for: "Account"))) {
                    NavigationLink(destination: ProfileView()) {
                        Text(LanguageManager.shared.localizedString(for: "Profile"))
                    }
                }
                
                Section(header: Text(LanguageManager.shared.localizedString(for: "Language & Region"))) {
                    HStack {
                        Text(LanguageManager.shared.localizedString(for: "Language"))
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
                        Text(LanguageManager.shared.localizedString(for: "Region"))
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
                Section(header: Text(LanguageManager.shared.localizedString(for: "Orders"))) {
                    NavigationLink(destination: OrdersView()) {
                        Text(LanguageManager.shared.localizedString(for: "Track orders"))
                    }
                }
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "Settings"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .id(viewModel.languageRefreshID)
    }
}

#Preview {
    SettingsView()
}
