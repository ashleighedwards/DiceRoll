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
import PhotosUI

@MainActor
class ProfileFormViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var middleName: String = ""
    @Published var surname: String = ""
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var profileImage: UIImage? = nil
    @Published var selectedImageItem: PhotosPickerItem? = nil {
        didSet {
            loadImage()
        }
    }
    
    @Published var showValidationError = false
    @Published var errorMessage = ""
    @Published var hasUnsavedNameChanges: Bool = false
    @Published var hasUnsavedProfileChanges: Bool = false
    
    private var initialFirst: String = ""
    private var initialMiddle: String = ""
    private var initialLast: String = ""
    private var initialEmail: String = ""
    private var initialDateOfBirth: Date = Date()
    private var initialImageData: Data?
    
    private var profile: Profile?
    private var viewContext: NSManagedObjectContext
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private func loadImage() {
        guard let item = selectedImageItem else { return }

        Task {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    self.profileImage = image
                    self.hasUnsavedProfileChanges = true
                }
            }
        }
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
                
                if let imageData = existing.imageData,
                   let uiImage = UIImage(data: imageData) {
                    profileImage = uiImage
                }
            }
            observeProfileChanges()
        } catch {
            errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
            showValidationError = true
        }
    }
    
    func saveProfile() {
        if profile == nil {
            profile = Profile(context: viewContext)
        }
        
        guard let profile = profile else { return }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedEmail.isEmpty && !isValidEmail(trimmedEmail) {
            showError("Please enter a valid email address.")
            return
        }

        profile.middleName = middleName
        profile.surname = surname
        profile.firstName = firstName
        profile.email = trimmedEmail.isEmpty ? nil : trimmedEmail

        profile.dob = dateOfBirth
        
        if let image = profileImage {
            profile.imageData = image.jpegData(compressionQuality: 0.8)
        }

        do {
            try viewContext.save()
            snapshotInitials()
            hasUnsavedNameChanges = false
            hasUnsavedProfileChanges = false
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showValidationError = true
        }
    }
    
    private func isValidEmail(_ s: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return s.range(of: pattern, options: .regularExpression) != nil
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showValidationError = true
    }
    
    var hasAnyUnsavedChanges: Bool {
        let imageDirty = (profileImage?.jpegData(compressionQuality: 0.8)) != initialImageData
        return hasUnsavedNameChanges || hasUnsavedProfileChanges || imageDirty
    }
    
    private func snapshotInitials() {
        initialFirst = firstName
        initialMiddle = middleName
        initialLast = surname
        initialEmail = email
        initialDateOfBirth = dateOfBirth
        initialImageData = profileImage?.jpegData(compressionQuality: 0.8)
    }

}
