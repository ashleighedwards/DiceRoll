//
//  DiceViewModelTests.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//


import XCTest
@testable import DiceRoll

final class DiceViewModelTests: XCTestCase {
    var viewModel: DiceViewModel!

    override func setUp() {
        super.setUp()
        viewModel = DiceViewModel()
    }

    func testInitialDiceCount() {
        XCTAssertEqual(viewModel.numbers.count, 1)
    }

    func testAddDie() {
        viewModel.addDie()
        XCTAssertEqual(viewModel.numbers.count, 2)
    }

    func testAddDieMaxLimit() {
        for _ in 0..<10 {
            viewModel.addDie()
        }
        XCTAssertEqual(viewModel.numbers.count, 6)
    }

    func testRemoveDie() {
        viewModel.addDie()
        viewModel.removeDie()
        XCTAssertEqual(viewModel.numbers.count, 1)
    }

    func testCannotRemoveLastDie() {
        viewModel.removeDie()
        XCTAssertEqual(viewModel.numbers.count, 1)
    }

    func testRollAllInRange() {
        viewModel.addDie()
        viewModel.addDie()
        viewModel.rollAll()

        for number in viewModel.numbers {
            XCTAssert((1...6).contains(number))
        }
    }

    func testRollSingleDie() {
        viewModel.addDie()
        viewModel.roll(index: 1)

        XCTAssert((1...6).contains(viewModel.numbers[1]))
    }
}
