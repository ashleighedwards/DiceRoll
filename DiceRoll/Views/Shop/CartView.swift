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
            VStack {
                List {
                    List {
                        Section(header:
                            HStack {
                                Text("Item")
                                    .font(.headline)
                                Spacer()
                                Text("Quantity")
                                    .font(.headline)
                                Spacer()
                                Text("Price")
                                    .font(.headline)
                            }
                            .padding(.vertical, 4)
                        ) {
                            ForEach(viewModel.items, id: \.objectID) { item in
                                HStack {
                                    Text(item.product?.productName ?? "Unknown")
                                    Spacer()
                                    Text("\(item.quantity)")
                                    Spacer()
                                    let price = item.product?.price ?? 0.0
                                    Text("£\(Double(item.quantity) * price, specifier: "%.2f")")
                                        .bold()
                                }
                            }
                        }
                    }

                    
                    if !viewModel.items.isEmpty {
                        HStack {
                            Spacer()
                            Text("Total: £\(viewModel.totalPrice, specifier: "%.2f")")
                                .bold()
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
