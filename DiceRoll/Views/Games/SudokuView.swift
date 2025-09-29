//
//  Second.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import SwiftUI

struct SudokuView: View {
    @StateObject var viewModel = SudokuViewModel()
    @State private var selectedCell: (row: Int, col: Int)? = nil

    
    var body: some View {
        VStack(spacing: 20) {
            Text(LanguageManager.shared.localizedString(for: "Sudoku"))
                .font(.largeTitle)
                .fontWeight(.bold)

            sudokuGrid

            numberPad
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    private var sudokuGrid: some View {
        VStack(spacing: 10) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(40), spacing: 0), count: 9), spacing: 0) {
                ForEach(0..<9) { row in
                    ForEach(0..<9) { col in
                        SudokuCellView(
                            cell: viewModel.board[row][col],
                            row: row,
                            col: col,
                            isSelected: selectedCell?.row == row && selectedCell?.col == col
                        )
                        .onTapGesture {
                            selectedCell = (row, col)
                        }
                    }
                }
            }
            .padding(4)
            .cornerRadius(4)
        }
    }
    
    private var numberPad: some View {
        HStack(spacing:10) {
            ForEach(1...9, id: \.self) { num in
                Button(action: {
                    if let selected = selectedCell {
                        viewModel.setCell(row: selected.row, col: selected.col, value: num)
                    }
                }) {
                    Text("\(num)")
                        .font(.title2)
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    SudokuView()
}
