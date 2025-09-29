//
//  CartView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUI
import CoreData

struct CartView: View {
    @FetchRequest(
        sortDescriptors: []
    ) private var cartItems: FetchedResults<CartItem>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cartItems) { item in
                    HStack {
                        Text(item.product?.productName ?? "Unknown")
                        Spacer()
                        Text("x\(item.quantity)")
                    }
                }
                
                if !cartItems.isEmpty {
                    HStack {
                        Spacer()
                        Text("Total: $\(totalPrice, specifier: "%.2f")")
                            .bold()
                    }
                }
            }
        }
    }
    
    private var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.product?.price ?? 0) * Double($1.quantity) }
    }
}
