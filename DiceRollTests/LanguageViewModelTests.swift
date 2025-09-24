//
//  LanguageViewModelTests.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 24/09/2025.
//

import XCTest
import CoreData
@testable import DiceRoll

final class LanguageViewModelTests: XCTestCase {
    var inMemoryContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        inMemoryContainer = NSPersistentContainer(name: "Model")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        inMemoryContainer.persistentStoreDescriptions = [description]

        let expectation = self.expectation(description: "Load persistent stores")
        inMemoryContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor func testDefaultLanguageAndRegion() {
        let viewModel = LanguageViewModel(context: inMemoryContainer.viewContext)
        XCTAssertEqual(viewModel.language, "en")
        XCTAssertEqual(viewModel.region, "GB")
    }

    @MainActor func testAvailableLanguagesNotEmpty() {
        let viewModel = LanguageViewModel(context: inMemoryContainer.viewContext)
        XCTAssertFalse(viewModel.availableLanguages.isEmpty, "Available languages should not be empty")
    }

    @MainActor func testAvailableRegionsNotEmpty() {
        let viewModel = LanguageViewModel(context: inMemoryContainer.viewContext)
        XCTAssertFalse(viewModel.availableRegions.isEmpty, "Available regions should not be empty")
    }

    @MainActor func testSaveAndReloadLanguageAndRegion() {
        let context = inMemoryContainer.viewContext

        let viewModel = LanguageViewModel(context: context)
        viewModel.language = "fr"
        viewModel.region = "FR"
        viewModel.saveLanguageAndRegion()

        let newViewModel = LanguageViewModel(context: context)
        XCTAssertEqual(newViewModel.language, "fr")
        XCTAssertEqual(newViewModel.region, "FR")
    }
}
