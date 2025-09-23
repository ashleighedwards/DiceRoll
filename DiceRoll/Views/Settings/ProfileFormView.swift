//
//  ProfileFormView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import SwiftUI
import CoreData

struct ProfileFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProfileFormViewModel
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: ProfileFormViewModel(context: context))
    }
        
    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                NavigationLink(destination: NameEntryView(viewModel: viewModel)) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(viewModel.fullName.isEmpty ? "" : viewModel.fullName)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.words)
                    }
                }
                HStack {
                    Text("Email")
                    Spacer()
                    TextField("", text: $viewModel.email)
                        .autocapitalization(.none)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                }
                
                HStack {
                    Text("Date of birth")
                    Spacer()
                    DatePicker("", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(.compact)

                }
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear(perform: viewModel.loadProfile)
        .alert(isPresented: $viewModel.showValidationError) {
            Alert(title: Text("Invalid Input"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveProfile()
                    dismiss()
                }
                .foregroundColor(viewModel.hasUnsavedProfileChanges ? .blue : .gray)
                .disabled(!viewModel.hasUnsavedProfileChanges)
            }
        }
        
    }
}

#Preview {
    ProfileFormView()
}
