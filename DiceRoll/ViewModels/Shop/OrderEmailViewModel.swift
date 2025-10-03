//
//  OrderEmailViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import Foundation
import CoreData

@MainActor
final class OrderEmailViewModel: ObservableObject {
    @Published var to: String
    @Published var subject: String
    @Published var body: String

    init(to: String, order: Order) {
        self.to = to
        self.subject = Self.makeSubject(order)
        self.body = Self.makeBody(order)
    }

    private static func makeSubject(_ order: Order) -> String {
        "Order Confirmation – \(order.orderId ?? "Order")"
    }

    private static func makeBody(_ order: Order) -> String {
        var lines: [String] = []
        lines.append("Thanks for your purchase!")
        lines.append("")
        lines.append("Order ID: \(order.orderId ?? "—")")

        if let date = order.createdAt {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .short
            lines.append("Date: \(df.string(from: date))")
        }

        lines.append("")
        lines.append("Items:")

        if let set = order.items as? Set<OrderItem> {
            let items = set.sorted { ($0.name ?? "") < ($1.name ?? "") }
            for it in items {
                let name = it.name ?? "Item"
                let qty = Int(it.quantity)
                let price = currencyString(it.unitPrice)
                lines.append("• \(name)  x\(qty)  @ \(price)")
            }
        }

        lines.append("")
        lines.append("Total: \(currencyString(order.total))")
        lines.append("")
        lines.append("Reply to this email if you need help.")
        return lines.joined(separator: "\n")
    }

    private static func currencyString(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "GBP"
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: value)) ?? String(format: "£%.2f", value)
    }
}
