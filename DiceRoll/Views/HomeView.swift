//
//  HomeView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//


import SwiftUI

struct HomeView: View {
    let items: [MenuDetails] = [
        MenuDetails(title: LanguageManager.shared.localizedString(for: "Sudoku"), destination: AnyView(SudokuView())),
        MenuDetails(title: LanguageManager.shared.localizedString(for: "Dice Roll"), destination: AnyView(DiceView()))
        ]
    
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: item.destination) {
                    HStack {
                        Image(systemName: "chevron.right")
                        Text(item.title)
                    }
                }
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "Games"))
        }
    }
}


#Preview {
    HomeView()
}
