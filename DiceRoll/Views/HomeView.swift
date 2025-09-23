//
//  HomeView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 23/09/2025.
//


import SwiftUI

struct HomeView: View {
    let items: [MenuDetails] = [
        MenuDetails(title: "Sudoku", destination: AnyView(SudokuView())),
        MenuDetails(title: "Dice roll", destination: AnyView(DiceView()))
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
            .navigationTitle("Games")
        }
    }
}


#Preview {
    HomeView()
}
