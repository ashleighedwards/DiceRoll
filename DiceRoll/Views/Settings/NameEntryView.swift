//
//  NameEntryView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import SwiftUI

struct NameEntryView: View {
    @ObservedObject var viewModel: ProfileFormViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(header: Text(LanguageManager.shared.localizedString(for: "Enter Your Name"))) {
                HStack {
                    Text(LanguageManager.shared.localizedString(for: "Forename")).foregroundColor(.gray)
                    Spacer()
                    TextField("", text: $viewModel.firstName)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                }
                HStack {
                    Text(LanguageManager.shared.localizedString(for: "Middle")).foregroundColor(.gray)
                    Spacer()
                    TextField("", text: $viewModel.middleName)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                }
                HStack {
                    Text(LanguageManager.shared.localizedString(for: "Surname")).foregroundColor(.gray)
                    Spacer()
                    TextField("", text: $viewModel.surname)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                }
            }
        }
        .navigationTitle(LanguageManager.shared.localizedString(for: "Name"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(LanguageManager.shared.localizedString(for: "Done")) {
                    viewModel.saveProfile()
                    dismiss()
                }
                .foregroundColor(viewModel.hasUnsavedNameChanges ? .blue : .gray)
                .disabled(!viewModel.hasUnsavedNameChanges)
            }
        }
    }
}
