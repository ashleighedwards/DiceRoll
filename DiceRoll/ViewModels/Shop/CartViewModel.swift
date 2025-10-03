//
//  CartViewModel.swift
//  DiceRoll
//
//  Created by Ashleigh Edwards on 30/09/2025.
//

import Foundation
import CoreData

@MainActor
class CartViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<CartItem>
    
    @Published var items: [CartItem] = []
    @Published var errorMessage: String?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CartItem.timestamp, ascending: true)
        ]
        
        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        frc.delegate = self
        fetchItems()
    }
    
    func fetchItems() {
        do {
            try frc.performFetch()
            items = frc.fetchedObjects ?? []
        } catch {
            errorMessage = "Failed to fetch"
        }
    }
    
    nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
                    self.items = self.frc.fetchedObjects ?? []
                }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product?.price ?? 0) * Double($1.quantity)}
    }
    
    func removeItem(_ item: CartItem) {
        context.delete(item)
        saveContext()
    }
    
    func clearCart() {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        if let items = try? context.fetch(request) {
            for item in items {
                if let product = item.product {
                    product.availability += item.quantity
                }
                context.delete(item)
            }
            saveContext()
        }
    }
    
    func purchaseItems() -> Order? {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        guard let cart = try? context.fetch(request), !cart.isEmpty else { return nil }
        
        let order = Order(context: context)
        order.id = UUID()
        order.orderId = OrderID.make()
        order.createdAt = Date()
        
        var total: Double = 0
        
        for item in cart {
            let orderItem = OrderItem(context: context)
            orderItem.name = item.product?.productName ?? "Item"
            orderItem.unitPrice = item.product?.price ?? 0
            orderItem.quantity = Int16(item.quantity)
            total += orderItem.unitPrice * Double(orderItem.quantity)
            
            orderItem.productId = item.product?.objectID.uriRepresentation().absoluteString
            
            order.addToItems(orderItem)
            
            if let product = item.product {
                product.availability = max(0, product.availability - item.quantity)
            }
            
            context.delete(item)
        }
        
        order.total = total
        saveContext()
        return order
    }

    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            errorMessage = "Failed to save"
        }
    }
}
