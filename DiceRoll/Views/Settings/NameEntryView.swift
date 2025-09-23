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
            Section(header: Text("Enter Your Name")) {
                HStack {
                    Text("Forename").foregroundColor(.gray)
                    Spacer()
                    TextField("", text: $viewModel.firstName)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                }
                HStack {
                    Text("Middle").foregroundColor(.gray)
                    Spacer()
                    TextField("", text: $viewModel.middleName)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                }
                HStack {
                    Text("Surname").foregroundColor(.gray)
                    Spacer()
                    TextField("", text: $viewModel.surname)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                }
            }
        }
        .navigationTitle("Name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.saveProfile()
                    dismiss()
                }
                .foregroundColor(viewModel.hasUnsavedNameChanges ? .blue : .gray)
                .disabled(!viewModel.hasUnsavedNameChanges)
            }
        }
    }
}
