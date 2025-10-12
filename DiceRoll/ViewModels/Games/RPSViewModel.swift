//
//  RPSViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 12/10/2025.
//

import Foundation

@MainActor
class RPSViewModel: ObservableObject {
    @Published var moves = RPSMove.all
    @Published var playerChoice: RPSMove? = nil
    @Published var appChoice: RPSMove = RPSMove.all.randomElement()!
    @Published var resultMessage = "Make your move!"
    @Published var score = 0
    
    func playRound(playerMove: RPSMove) {
        playerChoice = playerMove
        appChoice = moves.randomElement()!

        if playerMove == appChoice {
            resultMessage = "It's a draw! Both chose \(playerMove.name) \(playerMove.name)."
        } else if didPlayerWin(player: playerMove, against: appChoice) {
            resultMessage = "You win! \(playerMove.name) beats \(appChoice.name)."
            score += 1
        } else {
            resultMessage = "You lose! \(appChoice.name) beats \(playerMove.name)."
            score = max(score - 1, 0)
        }
    }
    
    func resetRound() {
        appChoice = moves.randomElement()!
        playerChoice = nil
    }
    
    private func didPlayerWin(player: RPSMove, against opponent: RPSMove) -> Bool {
        switch (player.name, opponent.name) {
        case ("Rock", "Scissors"), ("Paper", "Rock"), ("Scissors", "Paper"):
            return true
        default:
            return false
        }
    }
}
