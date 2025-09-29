//
//  ProductsView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUI
import CoreData

struct ProductsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.productName, ascending: true)]
    ) private var products: FetchedResults<Product>
    
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(products) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.productName ?? "Unknown")
                            Text("$\(product.price, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if let item = viewModel.cartItem(for: product) {
                            QuantityControl(
                                item: item,
                                onIncrement: { viewModel.incrementCartItem(item) },
                                onDecrement: { viewModel.decrementCartItem(item) }
                            )
                        } else {
                            Button {
                                viewModel.addToCart(product: product)
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                            }
                            .buttonStyle(.plain)
                            .disabled(product.availability <= 0)
                        }
                    }
                }
            }
        }
    }
}
