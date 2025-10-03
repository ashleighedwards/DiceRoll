//
//  OrderSearchViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 03/10/2025.
//

import Foundation
import CoreData


@MainActor
final class OrderSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var foundOrder: Order?
    @Published var lastError: String?
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func submit() {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            foundOrder = nil
            lastError = nil
            return
        }
        
        let req: NSFetchRequest<Order> = Order.fetchRequest()
        req.predicate = NSPredicate(format: "orderId ==[c] %@", q)
        req.fetchLimit = 1
        
        do {
            foundOrder = try context.fetch(req).first
            lastError = (foundOrder == nil) ? "No order found for ID “\(q)”." : nil
        } catch {
            foundOrder = nil
            lastError = error.localizedDescription
        }
    }
    
    func clear() {
        foundOrder = nil
        lastError = nil
        query = ""
    }
}
