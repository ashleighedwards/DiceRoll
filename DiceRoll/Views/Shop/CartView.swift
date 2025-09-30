//
//  CartView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUI
import CoreData

struct CartView: View {
    @ObservedObject private var viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.objectID) { item in
                    HStack {
                        Text(item.product?.productName ?? "Unknown")
                        Spacer()
                        Text("x\(item.quantity)")
                    }
                }
                
                if !viewModel.items.isEmpty {
                    HStack {
                        Spacer()
                        Text("Total: £\(viewModel.totalPrice, specifier: "%.2f")")
                            .bold()
                    }
                }
            }
        }
    }
}
