//
//  RPSMove.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 12/10/2025.
//

import Foundation

struct RPSMove: Identifiable, Equatable {
    let id = UUID()
    let name: String
    
    static let all: [RPSMove] = [
        RPSMove(name: "Rock"),
        RPSMove(name: "Paper"),
        RPSMove(name: "Scissors")
    ]
}

