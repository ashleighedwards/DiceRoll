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
    @StateObject private var viewModel: ProfileFormViewModel
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: ProfileFormViewModel(context: context))
    }
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Name", text: $viewModel.name)
                        .autocapitalization(.words)
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    TextField("Age", text: $viewModel.age)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Save Profile") {
                        if viewModel.isValidForm() {
                            viewModel.saveProfile()
                        } else {
                            viewModel.showValidationError = true
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .onAppear(perform: viewModel.loadProfile)
            .alert("Saved", isPresented: $viewModel.showSuccessMessage) {
                Button("OK", role: .cancel) {}
            }
            .alert(isPresented: $viewModel.showValidationError) {
                Alert(title: Text("Invalid Input"),
                      message: Text(viewModel.errorMessage),
                      dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    ProfileFormView()
}
