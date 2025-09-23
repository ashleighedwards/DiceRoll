//
//  ProfileFormViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import Foundation
import CoreData
import SwiftUI
import Combine

@MainActor
class ProfileFormViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var middleName: String = ""
    @Published var surname: String = ""
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var dateOfBirth: Date = Date()
    
    @Published var showValidationError = false
    @Published var errorMessage = ""
    @Published var hasUnsavedNameChanges: Bool = false
    @Published var hasUnsavedProfileChanges: Bool = false
    
    private var initialFirst: String = ""
    private var initialMiddle: String = ""
    private var initialLast: String = ""
    private var initialEmail: String = ""
    private var initialDateOfBirth: Date = Date()
    
    private var profile: Profile?
    private var viewContext: NSManagedObjectContext
    
    private var cancellables = Set<AnyCancellable>()
    private var profileCancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadProfile()
        observeNameChanges()
    }
    
    private func observeNameChanges() {
        initialFirst = firstName
        initialMiddle = middleName
        initialLast = surname
        
        Publishers.CombineLatest3($firstName, $middleName, $surname)
            .map { [weak self] first, middle, last in
                return first != self?.initialFirst ||
                       middle != self?.initialMiddle ||
                       last != self?.initialLast
            }
            .assign(to: &$hasUnsavedNameChanges)
        
        Publishers.CombineLatest3($firstName, $middleName, $surname)
            .map { first, middle, last in
                [first, middle, last].filter { !$0.isEmpty }.joined(separator: " ")
            }
            .assign(to: &$fullName)
    }
    
    func observeProfileChanges() {
        initialEmail = email
        initialDateOfBirth = dateOfBirth

        Publishers.CombineLatest($email, $dateOfBirth)
            .map { [weak self] currentEmail, currentDOB in
                guard let self = self else { return false }
                return currentEmail != self.initialEmail || currentDOB != self.initialDateOfBirth
            }
            .removeDuplicates()
            .assign(to: &$hasUnsavedProfileChanges)
    }

    
    func loadProfile() {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        request.fetchLimit = 1

        do {
            if let existing = try viewContext.fetch(request).first {
                profile = existing
                firstName = existing.firstName ?? ""
                surname = existing.surname ?? ""
                middleName = existing.middleName ?? ""
                email = existing.email ?? ""
                dateOfBirth = existing.dob ?? Date()
            }
            observeProfileChanges()
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
            errorMessage = "Please ensure name and valid email are filled. \(email)"
            showValidationError = true
            return
        }

        profile.middleName = middleName
        profile.surname = surname
        profile.firstName = firstName
        profile.email = email
        profile.dob = dateOfBirth

        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showValidationError = true
        }
    }
    
    func isValidForm() -> Bool {
        !firstName.isEmpty && email.contains("@")
    }
}
