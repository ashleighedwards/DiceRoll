//
//  ProfileFormView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import SwiftUI
import CoreData
import _PhotosUI_SwiftUI

struct ProfileFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ProfileFormViewModel
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: ProfileFormViewModel(context: context))
    }
        
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        if let image = viewModel.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                        }

                        PhotosPicker(
                            selection: $viewModel.selectedImageItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text(LanguageManager.shared.localizedString(for: "Edit"))
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                    Spacer()
                }
                .background(Color.clear)
                .listRowBackground(Color.clear)

            }
        
            Section(header: Text(LanguageManager.shared.localizedString(for: "Personal Info"))) {
                NavigationLink(destination: NameEntryView(viewModel: viewModel)) {
                    HStack {
                        Text(LanguageManager.shared.localizedString(for: "Name"))
                        Spacer()
                        Text(viewModel.fullName.isEmpty ? "" : viewModel.fullName)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.words)
                    }
                }
                HStack {
                    Text(LanguageManager.shared.localizedString(for: "Email"))
                    Spacer()
                    TextField("", text: $viewModel.email)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                }
                
                HStack {
                    Text(LanguageManager.shared.localizedString(for: "Date of birth"))
                    Spacer()
                    DatePicker("", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(.compact)

                }
            }
        }
        .navigationTitle(LanguageManager.shared.localizedString(for: "Edit Profile"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.loadProfile)
        .alert(isPresented: $viewModel.showValidationError) {
            Alert(title: Text(LanguageManager.shared.localizedString(for: "Invalid Input")),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(LanguageManager.shared.localizedString(for: "Save")) {
                    viewModel.saveProfile()
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
