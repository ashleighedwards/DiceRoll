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
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.surname, "")
        XCTAssertEqual(viewModel.email, "")
    }

    @MainActor func testIsValidFormPassesWithValidInput() {
        let viewModel = ProfileFormViewModel(context: inMemoryContainer.viewContext)
        viewModel.firstName = "Ashleigh"
        viewModel.email = "ashleigh@example.com"

        XCTAssertTrue(viewModel.isValidForm())
    }

    @MainActor func testSaveProfileWithoutExistingProfileFails() {
        let viewModel = ProfileFormViewModel(context: inMemoryContainer.viewContext)
        viewModel.firstName = "Ashleigh"
        viewModel.email = "ashleigh@example.com"

        viewModel.saveProfile()

        XCTAssertTrue(viewModel.showValidationError)
        XCTAssertEqual(viewModel.errorMessage, "No profile found to update.")
    }

    @MainActor func testSaveProfileWithValidData() {
        // Preload a profile
        let context = inMemoryContainer.viewContext
        let profile = Profile(context: context)
        profile.firstName = "Old"
        profile.surname = "Name"
        profile.email = "old@email.com"
        try? context.save()

        let viewModel = ProfileFormViewModel(context: context)
        viewModel.firstName = "New"
        viewModel.surname = "Name"
        viewModel.email = "new@email.com"

        viewModel.saveProfile()

        XCTAssertFalse(viewModel.showValidationError)
        context.refresh(profile, mergeChanges: true)
        XCTAssertEqual(profile.firstName, "New")
        XCTAssertEqual(profile.email, "new@email.com")
    }

}
