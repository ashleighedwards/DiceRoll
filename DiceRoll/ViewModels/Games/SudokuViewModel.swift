//
//  SudokuViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import Foundation

class SudokuViewModel: ObservableObject {
    @Published var board: [[SudokuCell]] = []
    
    init() {
        generatePuzzle()
    }
    
    func generatePuzzle() {
        let fullBoard = generateFullBoard()

        board = fullBoard.map { row in
            row.map { value in
                let shouldHide = Bool.random()
                return SudokuCell(
                    value: shouldHide ? 0 : value,
                    isFixed: !shouldHide
                )
            }
        }
    }
    
    func setCell(row: Int, col: Int, value: Int) {
        if !board[row][col].isFixed {
            board[row][col].value = value
        }
    }
    
    private func generateFullBoard() -> [[Int]] {
        var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)

        func isValid(_ row: Int, _ col: Int, _ num: Int) -> Bool {
            for i in 0..<9 {
                if board[row][i] == num || board[i][col] == num {
                    return false
                }
            }

            let startRow = (row / 3) * 3
            let startCol = (col / 3) * 3

            for r in startRow..<startRow + 3 {
                for c in startCol..<startCol + 3 {
                    if board[r][c] == num {
                        return false
                    }
                }
            }

            return true
        }

        func fillBoard() -> Bool {
            for row in 0..<9 {
                for col in 0..<9 {
                    if board[row][col] == 0 {
                        let numbers = (1...9).shuffled()
                        for num in numbers {
                            if isValid(row, col, num) {
                                board[row][col] = num
                                if fillBoard() { return true }
                                board[row][col] = 0
                            }
                        }
                        return false
                    }
                }
            }
            return true
        }

        _ = fillBoard()
        return board
    }
}
