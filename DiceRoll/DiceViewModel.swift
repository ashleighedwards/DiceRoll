//
//  DiceViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import Foundation

class DiceViewModel: ObservableObject {
    @Published var numbers: [Int] = [1]
    
    func rollAll() {
        for i in numbers.indices {
            numbers[i] = Int.random(in: 1...6)
        }
    }
    
    func roll(index: Int) {
        guard numbers.indices.contains(index) else { return }
        
        numbers[index] = Int.random(in: 1...6)
    }
    
    func addDie() {
        if numbers.count < 6 {
            numbers.append(1)
        }
    }
    
    func removeDie() {
        if numbers.count > 1 {
            numbers.removeLast()
        }
    }
}
