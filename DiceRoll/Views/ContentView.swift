//
//  ContentView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DiceView()
                .tabItem {
                    Label("Dice", systemImage: "die.face.5.fill")
                }

            SudokuView()
                .tabItem {
                    Label("Sudoku", systemImage: "gearshape.fill")
                }
        }
    }
}


#Preview {
    ContentView()
}
