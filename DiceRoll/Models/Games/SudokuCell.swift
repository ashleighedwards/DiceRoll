//
//  SudokuCell.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import Foundation

struct SudokuCell: Identifiable {
    let id = UUID()
    var value: Int
    var isFixed: Bool
}
