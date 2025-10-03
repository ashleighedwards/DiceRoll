//
//  OrderEmailFormatter.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import Foundation

enum OrderEmailFormatter {
    static func subject(for order: Order) -> String {
        "Order Confirmation – \(order.orderId ?? "Order")"
    }

    static func body(for order: Order) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short

        let dateStr = df.string(from: order.createdAt ?? Date())
        var lines: [String] = []
        lines.append("Thanks for your purchase!")
        lines.append("")
        lines.append("Order ID: \(order.orderId ?? "—")")
        lines.append("Date: \(dateStr)")
        lines.append("")
        lines.append("Items:")

        if let set = order.items as? Set<OrderItem> {
            let items = set.sorted { ($0.name ?? "") < ($1.name ?? "") }
            for it in items {
                let name = it.name ?? "Item"
                let qty = Int(it.quantity)
                let price = String(format: "£%.2f", it.unitPrice)
                lines.append("• \(name)  x\(qty)  @ \(price)")
            }
        }

        lines.append("")
        lines.append(String(format: "Total: £%.2f", order.total))
        lines.append("")
        lines.append("We’ll be in touch if anything changes. Reply to this email if you need help.")

        return lines.joined(separator: "\n")
    }
}
