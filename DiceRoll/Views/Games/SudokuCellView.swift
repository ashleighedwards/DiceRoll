//
//  SudokuCellView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import SwiftUI

struct SudokuCellView: View {
    var cell: SudokuCell
    var row: Int
    var col: Int
    var isSelected: Bool

    var body: some View {
        Text(cell.value == 0 ? "" : "\(cell.value)")
            .frame(width: 40, height: 40)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.white)
            .overlay(
                Rectangle()
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .font(.system(size: 20, weight: cell.isFixed ? .bold : .regular))
            .foregroundColor(cell.isFixed ? .black : .blue)
    }

    var borderWidth: CGFloat {
        var width: CGFloat = 1
        if (col + 1) % 3 == 0 { width += 1 } // right edge of 3x3 box
        if (row + 1) % 3 == 0 { width += 1 } // bottom edge of 3x3 box
        return width
    }

    var borderColor: Color {
        .black
    }
}


#Preview {
    SudokuCellView(
        cell: SudokuCell(value: 5, isFixed: true),
                row: 0,
                col: 0,
                isSelected: true
    )
}
