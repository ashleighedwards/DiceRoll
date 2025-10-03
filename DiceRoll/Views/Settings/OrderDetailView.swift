//
//  OrderDetailView.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import SwiftUICore
import SwiftUI

struct OrderDetailView: View {
    let order: Order
    
    var items: [OrderItem] {
        ((order.items as? Set<OrderItem>) ?? [])
            .sorted { ($0.name ?? "") < ($1.name ?? "") }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(order.createdAt ?? Date(), style: .date)
                    Spacer()
                    Text(String(format: "£%.2f", order.total))
                        .bold()
                        .monospacedDigit()
                }
                .foregroundStyle(.secondary)
            }
            
            Divider().opacity(0.3)

            if items.isEmpty {
                Text("No items on this order.").foregroundStyle(.secondary)
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Text("Item").font(.subheadline.weight(.semibold))
                        Spacer()
                        Text("Qty").font(.subheadline.weight(.semibold))
                            .frame(width: 40, alignment: .trailing)
                        Text("Price").font(.subheadline.weight(.semibold))
                            .frame(width: 80, alignment: .trailing)
                    }
                    ForEach(items, id: \.objectID) { it in
                        HStack {
                            Text(it.name ?? "Item")
                                .lineLimit(1)
                            Spacer()
                            Text("x\(it.quantity)")
                                .frame(width: 40, alignment: .trailing)
                                .monospacedDigit()
                            Text(String(format: "£%.2f", it.unitPrice))
                                .frame(width: 80, alignment: .trailing)
                                .monospacedDigit()
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
    }
}
