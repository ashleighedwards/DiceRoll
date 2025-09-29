//
//  ProductViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 29/09/2025.
//

import Foundation
import CoreData

@MainActor
class ProductViewModel: ObservableObject {
    private var context: NSManagedObjectContext
    @Published var errorMessage: String?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func cartItem(for product: Product) -> CartItem? {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "product == %@", product)
        return try? context.fetch(request).first
    }
    
    func seedProductsIfNeeded() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        if (try? context.count(for: request)) == 0 {
            CSVLoader.loadProductsFromCSV(into: context)
        }
    }
    
    func addToCart(product: Product) {
        if let existing = cartItem(for: product) {
            existing.quantity += 1
            existing.timestamp = Date()
        } else {
            let newItem = CartItem(context: context)
            newItem.id = UUID()
            newItem.quantity = 1
            newItem.product = product
            newItem.timestamp = Date()
        }
        saveContext()
    }
    
    func incrementCartItem(_ item: CartItem) {
        item.quantity += 1
        item.timestamp = Date()
        saveContext()
    }
    
    func decrementCartItem(_ item: CartItem) {
        if item.quantity > 1 {
            item.quantity -= 1
        } else {
            context.delete(item)
        }
        saveContext()
    }
    
    func clearExpiredCartItems() {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        let expiryDate = Date().addingTimeInterval(-3600)
        
        request.predicate = NSPredicate(format: "timestamp < %@", expiryDate as NSDate)
        
        do {
            let expiredItems = try context.fetch(request)
            for item in expiredItems {
                context.delete(item)
            }
            try context.save()
        } catch {
            errorMessage = "Failed to clear items"
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            errorMessage = "❌ Failed to save: \(error.localizedDescription)"
        }
    }
}
