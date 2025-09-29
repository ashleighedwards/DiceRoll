//
//  SwiftUIView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 20/09/2025.
//

import SwiftUI

struct DiceView: View {
    @StateObject var viewModel = DiceViewModel()
    
    var body: some View {        
        VStack {
            VStack {
                if viewModel.numbers.count <= 2 {
                    HStack {
                        ForEach(0..<viewModel.numbers.count, id: \.self) { index in
                            diceView(index: index)
                        }
                    }
                } else {
                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0..<viewModel.numbers.count, id: \.self) { index in
                            diceView(index: index)
                        }
                    }
                }
                Spacer()

                Button(action:{
                    viewModel.rollAll()
                }) {
                    Text(LanguageManager.shared.localizedString(for: "Roll")).fontWeight(.bold).font(.system(size: 50))
                }
            }
            HStack {
                Button(action: {
                    viewModel.addDie()
                }) {
                    Text("+").fontWeight(.bold).font(.system(size: 50))
                }.frame(maxWidth: .infinity).disabled(viewModel.numbers.count >= 6)
                
                Button(action: {
                    viewModel.removeDie()
                }) {
                    Text("-").fontWeight(.bold).font(.system(size: 50))
                }.frame(maxWidth: .infinity).disabled(viewModel.numbers.count <= 1)
            }
            
        }
        .padding()
    }
    
    func diceView(index: Int) -> some View {
        Image("dice\(viewModel.numbers[index])")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                viewModel.numbers[index] = Int.random(in: 1...6)
            }
    }
}

#Preview {
    DiceView()
}
