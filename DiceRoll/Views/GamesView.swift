//
//  GamesView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//


import SwiftUI

struct GamesView: View {
    var menuItems: [MenuDetails] {
        [
            MenuDetails(title: LanguageManager.shared.localizedString(for: "Sudoku"), destination: AnyView(SudokuView())),
            MenuDetails(title: LanguageManager.shared.localizedString(for: "Dice Roll"), destination: AnyView(DiceView())),
            MenuDetails(title: LanguageManager.shared.localizedString(for: "Rock Paper Scissors"), destination: AnyView(RPSView())),
            MenuDetails(
                title: LanguageManager.shared.localizedString(for: "Dual N-back"),
                destination: AnyView(DualNBackView())
            )

        ]
    }
    
    var body: some View {
        NavigationView {
            List(menuItems) { item in
                NavigationLink(destination: item.destination) {
                    HStack {
                        Text(item.title)
                    }
                }
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "Games"))
        }
    }
}

