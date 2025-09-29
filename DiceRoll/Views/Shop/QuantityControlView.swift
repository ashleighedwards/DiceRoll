//
//  QuantityControlView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import SwiftUICore
import SwiftUI

struct QuantityControl: View {
    @ObservedObject var item: CartItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onDecrement) {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
            }
            .buttonStyle(.plain)
            .disabled(item.quantity == 0)
            
            Text("\(item.quantity)")
                .font(.subheadline)
                .frame(minWidth: 20)
            
            Button(action: onIncrement) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
            .buttonStyle(.plain)
        }
    }
}
