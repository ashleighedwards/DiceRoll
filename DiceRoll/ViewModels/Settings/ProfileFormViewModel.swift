//
//  ProfileFormViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class ProfileFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var age: String = ""
    
    @Published var showValidationError = false
    @Published var showSuccessMessage = false
    @Published var errorMessage = ""
    
    private var profile: Profile?
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadProfile()
    }
    
    func loadProfile() {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        request.fetchLimit = 1

        do {
            if let existing = try viewContext.fetch(request).first {
                profile = existing
                name = existing.name ?? ""
                email = existing.email ?? ""
                age = String(existing.age)
            }
        } catch {
            errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
            showValidationError = true
        }
    }
    
    func saveProfile() {
        guard let profile = profile else {
            errorMessage = "No profile found to update."
            showValidationError = true
            return
        }

        guard isValidForm() else {
            errorMessage = "Please ensure name and valid email are filled."
            showValidationError = true
            return
        }

        profile.name = name
        profile.email = email
        profile.age = Int64(age) ?? 0

        do {
            try viewContext.save()
            showSuccessMessage = true
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showValidationError = true
        }
    }
    
    func isValidForm() -> Bool {
        !name.isEmpty && email.contains("@")
    }
}
