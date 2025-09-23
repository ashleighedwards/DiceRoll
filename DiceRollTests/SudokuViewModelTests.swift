//
//  SudokuViewModelTests.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//

import XCTest
@testable import DiceRoll

final class SudokuViewModelTests: XCTestCase {
    
    func testGeneratePuzzleCreates9x9Board() {
        let viewModel = SudokuViewModel()
        XCTAssertEqual(viewModel.board.count, 9, "Board should have 9 rows")
        for row in viewModel.board {
            XCTAssertEqual(row.count, 9, "Each row should have 9 columns")
        }
    }
    
    func testFixedAndHiddenCellsExist() {
        let viewModel = SudokuViewModel()
        let flatBoard = viewModel.board.flatMap { $0 }
        
        let fixedCells = flatBoard.filter { $0.isFixed }
        let editableCells = flatBoard.filter { !$0.isFixed }
        
        XCTAssertFalse(fixedCells.isEmpty, "There should be some fixed (pre-filled) cells")
        XCTAssertFalse(editableCells.isEmpty, "There should be some hidden (editable) cells")
    }
    
    func testSetCellOnlyChangesNonFixedCells() {
        let viewModel = SudokuViewModel()
        
        if let row = viewModel.board.firstIndex(where: { row in row.contains(where: { !$0.isFixed }) }) {
            let col = viewModel.board[row].firstIndex(where: { !$0.isFixed })!
            
            viewModel.setCell(row: row, col: col, value: 5)
            XCTAssertEqual(viewModel.board[row][col].value, 5, "Value should update for editable cell")
        }
    }
    
    func testSetCellDoesNotChangeFixedCells() {
        let viewModel = SudokuViewModel()
        
        if let row = viewModel.board.firstIndex(where: { row in row.contains(where: { $0.isFixed }) }) {
            let col = viewModel.board[row].firstIndex(where: { $0.isFixed })!
            let originalValue = viewModel.board[row][col].value
            
            viewModel.setCell(row: row, col: col, value: 9)
            XCTAssertEqual(viewModel.board[row][col].value, originalValue, "Value should not change for fixed cell")
        }
    }
    
    func testGeneratedFullBoardIsValid() {
        let viewModel = SudokuViewModel()
        let fullBoard = viewModel.board.map { row in
            row.map { $0.isFixed ? $0.value : 0 }
        }
        
        func isValidSudoku(board: [[Int]]) -> Bool {
            for i in 0..<9 {
                var rowSet = Set<Int>()
                var colSet = Set<Int>()
                var boxSet = Set<Int>()
                
                for j in 0..<9 {
                    let rowVal = board[i][j]
                    let colVal = board[j][i]
                    let boxVal = board[(i/3)*3 + j/3][(i%3)*3 + j%3]
                    
                    if rowVal != 0 && !rowSet.insert(rowVal).inserted { return false }
                    if colVal != 0 && !colSet.insert(colVal).inserted { return false }
                    if boxVal != 0 && !boxSet.insert(boxVal).inserted { return false }
                }
            }
            return true
        }
        
        XCTAssertTrue(isValidSudoku(board: fullBoard), "Generated board should be valid Sudoku")
    }
}
