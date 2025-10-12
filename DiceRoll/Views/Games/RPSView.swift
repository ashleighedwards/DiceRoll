//
//  RPSView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 12/10/2025.
//

import SwiftUI

struct RPSView: View {
    @StateObject private var viewModel = RPSViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Rock Paper Scissors")
                .font(.largeTitle.bold())
            
            Text("Score: \(viewModel.score)")
                .font(.headline)
            
            Text(viewModel.resultMessage)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            HStack(spacing: 25) {
                ForEach(viewModel.moves) { move in
                    Button {
                        viewModel.playRound(playerMove: move)
                    } label: {
                        Text("\(move.name)")
                            .font(.title3.bold())
                            .padding()
                            .frame(minWidth: 120)
                            .background(Color.blue.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
            
            Button("Play Again") {
                viewModel.resetRound()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .navigationTitle("R P S")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RPSView()
}
