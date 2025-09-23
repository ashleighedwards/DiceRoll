//
//  ProfileFormViewModelTests.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import XCTest
import CoreData
@testable import DiceRoll

final class ProfileFormViewModelTests: XCTestCase {
    var inMemoryContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        inMemoryContainer = NSPersistentContainer(name: "Model")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        inMemoryContainer.persistentStoreDescriptions = [description]

        let expectation = self.expectation(description: "Load Persistent Stores")
        inMemoryContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    @MainActor func testInitialStateIsEmpty() {
        let viewModel = ProfileFormViewModel(context: inMemoryContainer.viewContext)
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.age, "")
    }

    @MainActor func testIsValidFormPassesWithValidInput() {
        let viewModel = ProfileFormViewModel(context: inMemoryContainer.viewContext)
        viewModel.name = "Ashleigh"
        viewModel.email = "ashleigh@example.com"

        XCTAssertTrue(viewModel.isValidForm())
    }

    @MainActor func testIsValidFormFailsWithInvalidInput() {
        let viewModel = ProfileFormViewModel(context: inMemoryContainer.viewContext)
        viewModel.name = ""
        viewModel.email = "not-an-email"

        XCTAssertFalse(viewModel.isValidForm())
    }

    @MainActor func testSaveProfileWithoutExistingProfileFails() {
        let viewModel = ProfileFormViewModel(context: inMemoryContainer.viewContext)
        viewModel.name = "Ashleigh"
        viewModel.email = "ashleigh@example.com"
        viewModel.age = "30"

        viewModel.saveProfile()

        XCTAssertTrue(viewModel.showValidationError)
        XCTAssertEqual(viewModel.errorMessage, "No profile found to update.")
    }

    @MainActor func testSaveProfileWithValidData() {
        // Preload a profile manually
        let context = inMemoryContainer.viewContext
        let profile = Profile(context: context)
        profile.name = "Old Name"
        profile.email = "old@email.com"
        profile.age = 25
        try? context.save()

        let viewModel = ProfileFormViewModel(context: context)
        viewModel.name = "New Name"
        viewModel.email = "new@email.com"
        viewModel.age = "40"

        viewModel.saveProfile()

        XCTAssertTrue(viewModel.showSuccessMessage)

        context.refresh(profile, mergeChanges: true)
        XCTAssertEqual(profile.name, "New Name")
        XCTAssertEqual(profile.email, "new@email.com")
        XCTAssertEqual(profile.age, 40)
    }
}
